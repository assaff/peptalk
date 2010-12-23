#!/usr/bin/python

'''
Created on Dec 4, 2010

@author: assaf

'''
VERSION_STRING = '%s v0.0.1, an atom clustering script for molecular structures.'

import os, sys, re, logging, subprocess, re
import numpy as np
from optparse import OptionParser
from matplotlib import pylab
from scipy.cluster.hierarchy import *
from scipy.spatial.distance import pdist, squareform, cdist
from scipy.stats.stats import pearsonr
from molecule import AtomFromPdbLine, Atom
from vector3d import pos_distance

parser = OptionParser(version=VERSION_STRING)
parser.set_defaults(verbose=True)
parser.add_option('-p', '--pdbfilename', #dest='pdbfilename',
                  help='input PDB file to cluster',)
parser.add_option('-b', '--b-factor-cutoff',
                  type='float', default=0.6,
                  help='B-factor cutoff. Only CA atoms with B-factor>CUTOFF will be clustered [default: %default]',)
parser.add_option('-m', '--clustering-method',
                  default='average',
                  help='clustering method [default: %default]',)
parser.add_option('-t', '--clustering-metric',
                  default='euclidean',
                  help='clustering metric [default: %default]')
parser.add_option('-d', '--diameter-cutoff',
                  type='float',
                  default=10.0,
                  help='maximum cluster diameter, in angstrom [default: %default]')
parser.add_option('-w', '--weight-by-bfactor',
                  action='store_true',
                  default=False,
                  help='calculate pairwise distances weighted by the pair\'s B-factor product [default: %default]')
parser.add_option('-k', '--connect-neighbor-clusters',
                  action='store_true',
                  default=False,
                  help='optional post processing that agglomerates neighboring clusters together [default: %default]')
parser.add_option('-c', '--neighbor-distance-cutoff',
                  type='float',
                  default=7.0,
                  help='the maximal distance between two clusters to still be considered neighbors')
parser.add_option('-D', '--binding-residues',
                  default=None,
                  help='provide a list of actual binding residues, for evaluating the success of ranking')
#parser.add_option('-c', '--hyper-pymol-output',
#                  default='/dev/null',
#                  help='name of pml file, for visualization of meta-clustering output [default: %default]')
parser.add_option('-B','--use-cbeta',
                  action='store_true',
                  default=False,
                  help='use C-beta atoms as representatives of receptor residues')
parser.add_option('-C', '--use-centroid',
                  action='store_true',
                  default=False,
                  help='use centroid coordinates as representatives of receptor residues.')
parser.add_option('-l', '--logfile',
                  default='/dev/null',
                  help='name of log file, mainly for debugging [default: %default]')
parser.add_option('-y', '--pymol-output',
                  default=None,
                  help='name of pml file, for visualization of output [default: %default]')
parser.add_option('-P', '--print-best-cluster',
                  default=None,
                  help='print residues of the best cluster into this file/stream',
                  )
parser.add_option('-v', '--visualize',
                  action='store_true',
                  default=False,
                  help='visualize the clustering results in PyMOL [default: %default]')

(options, args) = parser.parse_args()

assert options.pdbfilename is not None, 'Please supply a valid PDB file as argument.'
if not os.path.exists(options.pdbfilename) or not os.path.isfile(options.pdbfilename):
    assert re.match(r'^[\w]{4}$', options.pdbfilename), 'At least provide a valid PDB code.'
    pdbid = options.pdbfilename.upper()
    options.pdbfilename = os.path.abspath(
                                os.path.join(
                                    os.path.dirname(sys.argv[0]),'../data/%s.results.pdb' %(pdbid.upper())))
    assert os.path.exists(options.pdbfilename), 'file %s does not exist.' % options.pdbfilename
    print >> sys.stderr, 'using %s as input PDB file.' % options.pdbfilename
    if options.binding_residues is not None and not os.path.exists(options.binding_residues): 
        assert re.match(r'^[\w]{4}$', options.binding_residues), 'At least provide a valid PDB code.'
        assert pdbid==options.binding_residues.upper(), 'please provide the same pdb code for pdb and binders'
        options.binding_residues = os.path.abspath(
                                    os.path.join(
                                        os.path.dirname(sys.argv[0]),'../BindingResidues/%s.res' %(pdbid)))
        assert os.path.exists(options.binding_residues), 'file %s does not exist.' % options.binding_residues
        print >> sys.stderr, 'using %s as binding residues source' % options.binding_residues

#---------------------------------------------- Logging

logging.basicConfig(filename=options.logfile, level=logging.DEBUG)
logging.debug(str(options))

#---------------------------------------------- Constants/parmeters
B_FACTOR_CUTOFF = options.b_factor_cutoff
CLUSTERING_METHOD = options.clustering_method # NOTE: centroid, median and ward methods require using euclidean metric 
CLUSTERING_METRIC = options.clustering_metric
CLUSTER_DIAMETER_CUTOFF = options.diameter_cutoff # in angstroms
PDB_ID = os.path.basename(options.pdbfilename).split('.')[0]

# CONSTANTS
META_CLUSTERING_METHOD = 'single'
META_CLUSTERING_METRIC = 'euclidean'
META_CLUSTERING_MARGIN = 4.0
META_CLUSTERING_DIAMETER_CUTOFF = options.diameter_cutoff + META_CLUSTERING_MARGIN
CLUSTERING_CRITERION = 'distance' # 'inconsistent' or 'distance'
NEIGHBOR_DISTANCE_CUTOFF = 7.0
#INCONSISTENCY_THRESHOLD = 0.02
CHAIN_RECEPTOR = 'A'
CHAIN_PEPTIDE = 'B'
RECEPTOR_ATOM_TYPE = 'CA'
if options.use_cbeta:
    RECEPTOR_ATOM_TYPE = 'CB'
PEPTIDE_ATOM_TYPE = 'CA'
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

def get_atoms(pdb_lines, filters=None):
    atoms = [AtomFromPdbLine(line) for line in pdb_lines if (line.startswith('ATOM') or
                                                             line.startswith('HETATM'))]
    for filter_function in filters:
        atoms = filter(filter_function, atoms)
    return atoms

def coords(atom):
#    assert type(atom) is Atom, '%s' % atom.pdb_str()
    # should use numpy array
    return [atom.pos.x, atom.pos.y, atom.pos.z]
    
    
def get_peptide_atoms(filename):
    pdb_lines = open(filename, 'r')
    peptide_filters = [filter_chain_eq(CHAIN_PEPTIDE),
                       filter_atom_type(PEPTIDE_ATOM_TYPE),]
    peptide_atoms = get_atoms(pdb_lines, peptide_filters)
    pdb_lines.close()
    return peptide_atoms

def get_positive_receptor_atoms(filename, bfactor_threshold):
    pdb_lines = open(filename, 'r')
    binder_filters = [filter_chain_eq(CHAIN_RECEPTOR),
                      filter_atom_type(RECEPTOR_ATOM_TYPE),
                      filter_bfactor_gt(B_FACTOR_CUTOFF),]
    binders = get_atoms(pdb_lines, binder_filters)
    pdb_lines.close()
    return binders

def centroid(residue_atoms, atom_weights=None):
    assert atom_weights is None or (atom_weights.ndim==1 and len(atom_weights)==len(residue_atoms))
    residue_coords = np.array([coords(atom) for atom in residue_atoms])
    centroid_coords = np.average(residue_coords, axis=0, weights=atom_weights)
    assert centroid_coords.ndim == 1
    return centroid_coords

def shift_coords_to_centroids(center_atoms, pdbfilename):
    pdb_lines = open(pdbfilename, 'r')
    # collect all atoms, i.e. filter only by chain and not atom type
    filters = [filter_chain_eq(CHAIN_RECEPTOR)]
    all_receptor_atoms = get_atoms(pdb_lines, filters)
    pdb_lines.close()
    for center_atom in center_atoms:
        residue_atoms = [atom for atom in all_receptor_atoms if atom.res_num==center_atom.res_num]
        # add a weight function for atom types here
        residue_atom_weights = None
        (center_atom.pos.x, center_atom.pos.y, center_atom.pos.z) = centroid(residue_atoms, residue_atom_weights)
    return center_atoms

def spatial_clustering_degree(atoms):
    distances = pdist(np.array([coords(atom) for atom in atoms]))
    score = np.power(distances, -1).sum() * np.power(len(atoms), 0)
    return score

def quasi_rmsd(atoms1, atoms2):
    coords1 = np.array([coords(atom) for atom in atoms1])
    coords2 = np.array([coords(atom) for atom in atoms2])
    distances = cdist(coords1, coords2)
    score = np.power(distances, -1).sum() / float((len(atoms1)*len(atoms2)))
    return np.power(score, .5)

def mini_rmsd(atoms1, atoms2):
    coords1 = np.array([coords(atom) for atom in atoms1])
    coords2 = np.array([coords(atom) for atom in atoms2])
    distances = cdist(coords1, coords2)
    cluster_res_proximities = np.power(distances.min(1),-1)
    score = 1./float(len(cluster_res_proximities)) * cluster_res_proximities.sum() 
#    for a in atoms1:
#        for b in atoms2:
#            score += 1 / pos_distance(a.pos, b.pos)
#    score *= float(1) / float(len(atoms1))  
    return score #sqrt(score)

def cluster_density_score(cluster_atoms):
    return spatial_clustering_degree(cluster_atoms)
    
def cluster_distance_with_peptide(cluster_atoms):
    peptide_atoms = get_peptide_atoms(pdb)
    logging.debug('Peptide CA atoms:')
    for atom in peptide_atoms: logging.debug(atom.pdb_str())
    return mini_rmsd(cluster_atoms, peptide_atoms)

def cluster_contacts_with_peptide(cluster_atoms):
    peptide_atoms = get_peptide_atoms(pdb)
    peptide_coords = map(coords, peptide_atoms)
    contacting_residues = [atom for atom in cluster_atoms \
                if cdist(np.array([coords(atom)]), peptide_coords).min() < 6]
    return len(contacting_residues)

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
        print >> output_stream, 'select %s, receptor and name %s and (resi %s); deselect' % (cluster_ca_object, RECEPTOR_ATOM_TYPE, cluster_resnum_str)
        print >> output_stream, 'select %s, br. %s; deselect' % (cluster_res_object, cluster_ca_object)
        print >> output_stream, 'delete %s' % (cluster_ca_object)
        print >> output_stream, 'color %s, %s' % (COLORS[cluster_num], cluster_res_object)
    return

def weighted_fclusterdata(coords_matrix, bfactor_vector=None):
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
        weight_matrix = np.power(np.outer(bfactor_vector,bfactor_vector),-1)
        pdistances = squareform(np.multiply(squareform(pdistances), weight_matrix))
    logging.debug('DISTANCE MATRIX:\n' + str(pdistances))

    Z = linkage(pdistances, method=CLUSTERING_METHOD, metric=CLUSTERING_METRIC)
    flat_clusters = fcluster(Z, t=CLUSTER_DIAMETER_CUTOFF, criterion=CLUSTERING_CRITERION)
    
    assert(len(flat_clusters) == coords_matrix.shape[0])
    logging.debug('FLAT CLUSTERS:\n' + str(flat_clusters))
    return flat_clusters

def find_closest_clusters(clusters_list):
    cluster_coords = [np.array([coords(atom) for atom in cluster]) for cluster in clusters_list]
    min_distance = np.inf
    neighbor_clusters = None
    for i in range(len(clusters_list)):
        for j in range(i+1, len(clusters_list)):
            dij = np.min(cdist(cluster_coords[i], cluster_coords[j]))
            if  dij < min_distance:
                min_distance = dij
                neighbor_clusters = (clusters_list[i], clusters_list[j])
#        print min_distance
    return (neighbor_clusters, min_distance)

if __name__ == '__main__':

    pdb = os.path.abspath(options.pdbfilename)

    pdb_atoms = get_positive_receptor_atoms(pdb, B_FACTOR_CUTOFF)
    if options.use_centroid:
        pdb_atoms = shift_coords_to_centroids(pdb_atoms, pdbfilename=pdb)

    logging.debug('Receptor peptide-binding CA atoms:')
    for atom in pdb_atoms: logging.debug(atom.pdb_str())
    
    coords_matrix = np.array([coords(atom) for atom in pdb_atoms])
    assert coords_matrix.shape[0]==len(pdb_atoms)

    weights = None
    if options.weight_by_bfactor:
        weights = np.array([atom.bfactor for atom in pdb_atoms])
    cluster_assignment = weighted_fclusterdata(coords_matrix, weights)

    clusters = [[atom for atom in pdb_atoms if cluster_assignment[pdb_atoms.index(atom)]==cluster_num] for cluster_num in set(cluster_assignment)]
    
    # testing
#    clusters = [[atom] for atom in pdb_atoms]
    

    if options.connect_neighbor_clusters:
        (neighbors, min_distance) = find_closest_clusters(clusters)
        while min_distance < options.neighbor_distance_cutoff:
            if neighbors is None:
                break
            clusters.remove(neighbors[0])
            clusters.remove(neighbors[1])
            clusters.insert(0, neighbors[0]+neighbors[1])
            (neighbors, min_distance) = find_closest_clusters(clusters)

    clusters = filter(lambda cluster: len(cluster) > 1, clusters)
    
    cluster_scoring_function = spatial_clustering_degree
    if options.binding_residues is not None:
        best_cluster = clusters[0]
        binding_filename = options.binding_residues
        assert os.path.isfile(binding_filename)
        assert os.path.exists(binding_filename)
        binders_file = open(binding_filename)
        actual_binders = np.array([[int(line.strip().split()[1])] for line in binders_file])
        actual_binders.sort()
        binders_file.close()
        cluster_binders = np.array([[atom.res_num] for atom in best_cluster])
        
        print 'cluster', cluster_binders
        print 'actual' , actual_binders
        distances = cdist(actual_binders, cluster_binders)
        mdta = distances.min(1) # minimal distances of actual binders to 
        mdta[mdta>3] = np.inf
#        print mdta
        assert actual_binders.shape[0]==mdta.shape[0]
        recovery = mdta[mdta<np.inf].shape[0] / float(mdta.shape[0])
        print '%.2f%'%(100*recovery)
        
#        score = 1./float(len(cluster_res_proximities)) * cluster_res_proximities.sum()
#    exit()
    clusters.sort(key=cluster_scoring_function, reverse=True)
    
    
    if clusters is None or len(clusters)==0:
        print 'ERROR_no_clusters_found'
        exit(1)
    clusters_quality = [cluster_contacts_with_peptide(cluster) for cluster in clusters]
    if np.argmax(clusters_quality)>0:
        print 'FAIL'
#    print clusters
#    print map(spatial_clustering_degree, clusters)
#    print map(cluster_contacts_with_peptide, clusters)
        # build an atom==>cluster mapping
#        cluster_centroid_coords = np.array([weighted_centroid(cluster) for cluster in clusters])
#        cluster_weights = np.array([np.mean([atom.bfactor for atom in cluster]) for cluster in clusters])

    if options.print_best_cluster is not None:
        cluster_file = open(options.print_best_cluster, 'w')
        for atom in sorted(clusters[0], key=lambda x: x.res_num):
            print >> cluster_file, '%s %d' % (atom.res_type.upper(), atom.res_num)
        cluster_file.close()
    if options.pymol_output is not None:
        PML = open(options.pymol_output, 'w')
        print >> PML, DEFAULT_PYMOL_INIT
        write_pymol_script(PML, clusters)
        PML.close()
    if options.visualize:
#        assert not options.pymol_output.startswith('/dev'), 'Cannot read from %s' % options.pymol_output
        TEMP_PML_FILENAME = '/tmp/temp%d.pml' % os.getpid()
        TEMP_PML = open(TEMP_PML_FILENAME, 'w')
        print >> TEMP_PML, DEFAULT_PYMOL_INIT
        write_pymol_script(TEMP_PML, clusters)
#        print >> TEMP_PML, 'save ../sessions/%s_Bvwk_b%.1f_d%.1f_c%.1f.pse; quit;' % (PDB_ID, options.b_factor_cutoff, options.diameter_cutoff, options.neighbor_distance_cutoff)
        TEMP_PML.close()
        SINK = open('/dev/null')
        subprocess.Popen(['pymol','-qd', '@%s' % TEMP_PML_FILENAME,], stdout=SINK, stderr=SINK)
        SINK.close()
#        os.remove(TEMP_PML_FILENAME)
    
    logging.shutdown()
    exit()