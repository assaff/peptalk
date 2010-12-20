#!/usr/bin/python

'''
Created on Dec 4, 2010

@author: assaf

'''
VERSION_STRING = '%s v0.0.1, an atom clustering script for molecular structures.'

import os, sys, re, logging, subprocess
import numpy as np
from optparse import OptionParser
from matplotlib import pylab
from scipy.cluster.hierarchy import *
from scipy.spatial.distance import pdist, squareform
from scipy.stats.stats import pearsonr
from molecule import AtomFromPdbLine, Atom
from vector3d import pos_distance

parser = OptionParser(version=VERSION_STRING)
parser.set_defaults(verbose=True)
parser.add_option('-p', '--pdbfilename', #dest='pdbfilename',
                  help='input PDB file to cluster',)
parser.add_option('-b', '--b-factor-cutoff',
                  type='float', default=0.7,
                  help='B-factor cutoff. Only CA atoms with B-factor>CUTOFF will be clustered [default: %default]',)
parser.add_option('-m', '--clustering-method',
                  default='average',
                  help='clustering method [default: %default]',)
parser.add_option('-t', '--clustering-metric',
                  default='euclidean',
                  help='clustering metric [default: %default]')
parser.add_option('-d', '--diameter-cutoff',
                  type='float', default=16.0,
                  help='maximum cluster diameter, in angstrom [default: %default]')
parser.add_option('-w', '--weight-by-bfactor',
                  action='store_true',
                  default=False,
                  help='calculate pairwise distances weighted by the pair\'s B-factor product [default: %default]')
parser.add_option('-l', '--logfile',
                  default='/dev/null',
                  help='name of log file, mainly for debugging [default: %default]')
parser.add_option('-y', '--pymol-output',
                  default='/dev/null',
                  help='name of pml file, for visualization of output [default: %default]')
parser.add_option('-s', '--meta-cluster',
                  action='store_true',
                  default=False,
                  help='cluster the resulting clusters again, by their centroid\'s coordinates [default: %default]')
parser.add_option('-c', '--meta-pymol-output',
                  default='/dev/null',
                  help='name of pml file, for visualization of meta-clustering output [default: %default]')
parser.add_option('-v', '--visualize',
                  action='store_true',
                  default=False,
                  help='visualize the clustering results in PyMOL [default: %default]')

(options, args) = parser.parse_args()
assert options.pdbfilename is not None and os.path.exists(options.pdbfilename), \
         'Please supply a valid PDB file as argument.'
#---------------------------------------------- Logging

logging.basicConfig(filename=options.logfile, level=logging.DEBUG)
logging.debug(str(options))

#---------------------------------------------- Constants/parmeters
B_FACTOR_CUTOFF = options.b_factor_cutoff
CLUSTERING_METHOD = options.clustering_method # NOTE: centroid, median and ward methods require using euclidean metric 
CLUSTERING_METRIC = options.clustering_metric
CLUSTER_DIAMETER_CUTOFF = options.diameter_cutoff # in angstroms

META_CLUSTERING_METHOD = 'single'
META_CLUSTERING_METRIC = 'euclidean'
META_CLUSTERING_MARGIN = 4.0
META_CLUSTERING_DIAMETER_CUTOFF = options.diameter_cutoff + META_CLUSTERING_MARGIN
# CONSTANTS
CLUSTERING_CRITERION = 'distance' # 'inconsistent' or 'distance'
NEIGHBOR_DISTANCE_CUTOFF = 7.0
#INCONSISTENCY_THRESHOLD = 0.02
CHAIN_RECEPTOR = 'A'
CHAIN_PEPTIDE = 'B'
ATOM_TYPE_CA = 'CA'
SUCCESS_MESSAGE = 'Success with %s: highest ranking cluster is closest to peptide' % os.path.basename(options.pdbfilename)
COLORS = ['red',
          'orange',
          'yellow',
          'forest',
          'green',
          'cyan',
          'blue',
          'violet',
          'magenta',
          'pink',
          'black',
          'teal',
          'brown',
          ]
DEFAULT_PYMOL_INIT = ';'.join(['load %s' % os.path.abspath(options.pdbfilename),
                               'bg white',
                               'hide everything',
                               'select receptor, chain A',
                               'deselect',
                               'select peptide, chain B',
                               'deselect',
                               'color yellow, peptide',
                               'show sticks, peptide',
                               'show spheres, receptor',
                               ''])
    

    
def filter_chain_eq(chain_constraint):
    return (lambda atom: atom.chain_id==chain_constraint)

def filter_atom_type(type_constraint):
    return (lambda atom: atom.type==type_constraint)

def filter_bfactor_gt(bfactor_cutoff):
    return (lambda atom: atom.bfactor>=bfactor_cutoff)

def test_clusters_ranking(clusters, clustering_score_function, actual_score_function):
    my_scoring = np.array([clustering_score_function(cluster) for cluster in clusters])
    real_scoring = np.array([actual_score_function(cluster) for cluster in clusters])
    pearson_coef = pearsonr(my_scoring, real_scoring)
    if np.argmax(my_scoring) == np.argmax(real_scoring):
        print SUCCESS_MESSAGE
    else:
        print 'FAILED on %s' % os.path.basename(options.pdbfilename)
    print 'Generally, pearson coefficient is: %f' % pearson_coef
    return pearson_coef

def get_atoms(pdb_lines, filters):
    atoms = [AtomFromPdbLine(line) for line in pdb_lines if (line.startswith('ATOM') or
                                                             line.startswith('HETATM'))]
    for filter_function in filters:
        atoms = filter(filter_function, atoms)
    return atoms
    
def get_peptide_ca_atoms(filename):
    pdb_lines = open(filename, 'r')
    peptide_filters = [filter_chain_eq(CHAIN_PEPTIDE),
                       filter_atom_type(ATOM_TYPE_CA),]
    peptide_atoms = get_atoms(pdb_lines, peptide_filters)
    pdb_lines.close()
    return peptide_atoms

def get_positive_ca_atoms(filename, bfactor_threshold):
    pdb_lines = open(filename, 'r')
    binder_filters = [filter_chain_eq(CHAIN_RECEPTOR),
                      filter_atom_type(ATOM_TYPE_CA),
                      filter_bfactor_gt(B_FACTOR_CUTOFF),]
    binders = get_atoms(pdb_lines, binder_filters)
    pdb_lines.close()
    return binders

def spatial_clustering_deg(atoms):
    score = 0
    for i in range(len(atoms)):
        for j in range(i + 1, len(atoms) - 1):
            score += 1 / pos_distance(atoms[i].pos, atoms[j].pos)
    return score


def quasi_rmsd(atoms1, atoms2):
    msd = 0
    for a in atoms1:
        for b in atoms2:
            msd += 1 / pos_distance(a.pos, b.pos)
    return msd #sqrt(msd)

def cluster_density_score(cluster_atoms):
    return spatial_clustering_deg(cluster_atoms)
    
def cluster_distance_with_peptide(cluster_atoms):
    peptide_atoms = get_peptide_ca_atoms(pdb)
    logging.debug('Peptide CA atoms:')
    for atom in peptide_atoms: logging.debug(atom.pdb_str())
    return quasi_rmsd(cluster_atoms, peptide_atoms)

def weighted_centroid(atoms):
    assert type(atoms) is list or type(atoms) is np.array
    coords = np.array([[atom.pos.x, atom.pos.y, atom.pos.z] for atom in atoms])
    weights = np.array([atom.bfactor for atom in atoms ])
    return np.average(coords, 0, weights)

def write_pymol_script(output_stream, clusters):
    print >> output_stream, 'color white, receptor'
    for cluster in clusters:
        if clusters.index(cluster) >= len(COLORS):
            logging.debug('out of colors - too many clusters!')
            break
        cluster_num = clusters.index(cluster, )
        cluster_ca_object = 'cluster%d_ca' % cluster_num
        cluster_res_object = 'cluster%d_%s' % (cluster_num, COLORS[cluster_num])
        cluster_resnum_str = re.sub(r'[\[\] ]', '', str(sorted([atom.res_num for atom in cluster])))
        print >> output_stream, 'select %s, receptor and name %s and (resi %s); deselect' % (cluster_ca_object, ATOM_TYPE_CA ,cluster_resnum_str)
        print >> output_stream, 'select %s, br. %s; deselect' % (cluster_res_object, cluster_ca_object)
        print >> output_stream, 'delete %s' % (cluster_ca_object)
        print >> output_stream, 'color %s, %s' % (COLORS[cluster_num], cluster_res_object)
    return

def cluster_and_rank(coords_matrix, bfactor_vector=None):
    '''
    Input:  N x 3 array of XYZ coordinates (practically a list of lists)
            bfactor_vector: an N-sized row vector of each observations bfactor (used as weight)
    Output: A list describing each vector's assignment to a cluster 
    '''
    logging.debug('VECTOR COORDINATES:\n' + str(coords_matrix))
    
#    flat_clusters = fclusterdata(coords_matrix, criterion=CLUSTERING_CRITERION, t=CLUSTER_DIAMETER_CUTOFF,
#                                 metric=CLUSTERING_METRIC, depth=2,
#                                 method=CLUSTERING_METHOD)

    pdistances = pdist(coords_matrix, metric=CLUSTERING_METRIC)
    if options.weight_by_bfactor and bfactor_vector is not None:
        # Weighting the distance matrix by pairwise bfactor product
        assert (type(bfactor_vector) is np.ndarray) and len(bfactor_vector.shape)<=2 and max(bfactor_vector.shape)==coords_matrix.shape[0]
        weight_matrix = float(1)/np.outer(bfactor_vector,bfactor_vector)
        pdistances = squareform(np.multiply(squareform(pdistances), weight_matrix))
    d = np.zeros((coords_matrix.shape[0],coords_matrix.shape[0]))
#    if CLUSTERING_METHOD=='single':
#        for i in range(len(pdistances)):
#            if pdistances[i]>NEIGHBOR_DISTANCE_CUTOFF: pdistances[i] = np.inf
    logging.debug('DISTANCE MATRIX:\n' + str(pdistances))

    Z = linkage(pdistances, method=CLUSTERING_METHOD, metric=CLUSTERING_METRIC)
    flat_clusters = fcluster(Z, t=CLUSTER_DIAMETER_CUTOFF, criterion=CLUSTERING_CRITERION)
    
#    dendrogram(Z)
#    pylab.show()

    assert(len(flat_clusters) == coords_matrix.shape[0])
    logging.debug('FLAT CLUSTERS:\n' + str(flat_clusters))
    return flat_clusters

if __name__ == '__main__':

    pdb = os.path.abspath(options.pdbfilename)

    pdb_atoms = get_positive_ca_atoms(pdb, B_FACTOR_CUTOFF)
    logging.debug('Receptor peptide-binding CA atoms:')
    for atom in pdb_atoms: logging.debug(atom.pdb_str())
    
    coords_matrix = np.array([
                              [atom.pos.x, atom.pos.y, atom.pos.z]
                              for atom in pdb_atoms
                              ])
    weights = None
    if options.weight_by_bfactor:
        weights = np.array([atom.bfactor for atom in pdb_atoms])
    cluster_assignment = cluster_and_rank(coords_matrix, weights)

    clusters = [[atom for atom in pdb_atoms if cluster_assignment[pdb_atoms.index(atom)] \
                 == cluster_num] for cluster_num in set(cluster_assignment)]
    clusters = filter(lambda cluster: len(cluster) > 1, clusters)
    clusters.sort(key=lambda atoms: spatial_clustering_deg(atoms), reverse=True)

#------- HYPER-CLUSTERING
#    cluster_centroids = [weighted_centroid(cluster) for cluster in clusters]


    
    PML = open(options.pymol_output, 'w')
    write_pymol_script(PML, clusters)
    PML.close()
    if options.visualize:
#        assert not options.pymol_output.startswith('/dev'), 'Cannot read from %s' % options.pymol_output
        TEMP_PML_FILENAME = '/tmp/temp%d.pml' % os.getpid()
        TEMP_PML = open(TEMP_PML_FILENAME, 'w')
        print >> TEMP_PML, DEFAULT_PYMOL_INIT
        write_pymol_script(TEMP_PML, clusters)
        TEMP_PML.close()
        subprocess.Popen(['pymol','-qd', '@%s' % TEMP_PML_FILENAME,],)
#        os.remove(TEMP_PML_FILENAME)
    
    logging.shutdown()
    exit()