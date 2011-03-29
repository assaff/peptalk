#!/usr/bin/python

'''
Created on Dec 4, 2010

@author: assaf

'''
VERSION_STRING = '%s v0.0.1, an atom clustering script for molecular structures.'

import os, sys, re, logging, subprocess, re
sys.path.append(os.path.join(os.path.dirname(sys.argv[0]), 'match'))
import numpy as np
from optparse import OptionParser
from itertools import chain
from glob import glob
#from matplotlib import pylab
from scipy.cluster.hierarchy import fcluster, fclusterdata, linkage
from scipy.spatial.distance import pdist, squareform, cdist
from scipy.stats.stats import pearsonr
from molecule import AtomFromPdbLine, Atom
from vector3d import pos_distance
import networkx as nx

parser = OptionParser(version=VERSION_STRING)
parser.set_defaults(verbose=True)
parser.add_option('-p', '--pdbfilename', #dest='pdbfilename',
                  help='input PDB file to cluster',)
parser.add_option('-b', '--b-factor-cutoff',
                  type='float', default=.001,
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
                  default=6.0,
                  help='the maximal distance between two clusters to still be considered neighbors')
parser.add_option('-B', '--use-cbeta',
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
parser.add_option('-v', '--visualize',
                  action='store_true',
                  default=False,
                  help='visualize the clustering results in PyMOL [default: %default]')
parser.add_option('-Y', '--output-pymol-script',
                  default=None,
                  help='name of pml file, for visualization of output [default: %default]')
parser.add_option('-S', '--output-pymol-session',
                  default=None,
                  help='save the visualization session as a pse [default: %default]')
parser.add_option('-R', '--output-clustering-report',
                  default=None,
                  help='where to dump clustering results [default: %default]',
                  )
parser.add_option('-N', '--closeness',
                  action='store_true',
                  default=False,
                  help='calculate closeness centrality for every surface residue')
parser.add_option('-f', '--fpocket',
                  default='',
                  help='fpocket parameters')

(options, args) = parser.parse_args()

assert options.pdbfilename is not None, 'Please supply a valid PDB file as argument.'
if not (os.path.exists(options.pdbfilename) and os.path.isfile(options.pdbfilename)):
    assert re.match(r'^[\w]{4}$', options.pdbfilename), 'At least provide a valid PDB code.'
    pdbid = options.pdbfilename.upper()
    options.pdbfilename = os.path.abspath(
                                os.path.join(
                                    os.path.dirname(sys.argv[0]), '../data/%s.results.classified_pdb_filename' % (pdbid.upper())))
    assert os.path.exists(options.pdbfilename), 'file %s does not exist.' % options.pdbfilename
    print >> sys.stderr, 'using %s as input PDB file.' % options.pdbfilename
    if options.binding_residues is not None and not os.path.exists(options.binding_residues): 
        assert re.match(r'^[\w]{4}$', options.binding_residues), 'At least provide a valid PDB code.'
        assert pdbid == options.binding_residues.upper(), 'please provide the same classified_pdb_filename code for classified_pdb_filename and binders'
        options.binding_residues = os.path.abspath(
                                    os.path.join(
                                        os.path.dirname(sys.argv[0]), '../BindingResidues/%s.res' % (pdbid)))
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
NEIGHBOR_CLUSTER_DISTANCE_CUTOFF = 7.0
NEIGHBOR_RESIDUE_DISTANCE_CUTOFF = 7.0
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
          'teal',
          'brown',
          ]
pymol_pdbid = os.path.basename(options.pdbfilename)[:4]
ftmap_dir = '/vol/ek/assaff/workspace/peptalk/data/peptiDB/bound/FTMapAnalysis/ftmapData/'
DEFAULT_PYMOL_INIT = ';'.join([
                               'load %s' % os.path.abspath(options.pdbfilename),
                               'bg white',
                               #'label %s, pos=[-20,-20,-20]' % pymol_pdbid,
                               'hide everything',
                               'select receptor_orig, chain A',
                               'deselect',
                               'show_as cartoon, receptor_orig',
                               'color grey, receptor_orig',
#                               'hide everything, receptor_orig',
                               'select peptide, chain B',
                               'deselect',
                               'color black, peptide',
                               'show_as cartoon, peptide',
                               'show sticks, peptide and !(name c+n+o)',
                               'create receptor, receptor_orig; color white, receptor; show surface, receptor',
#                               'hide everything, receptor',
                               'set transparency, 0.4, receptor',
                               'select binding_site, receptor within 4 of peptide',
                               'color white, binding_site',
                               'set transparency, 0, binding_site',
                               'load %s' % os.path.join(ftmap_dir, pymol_pdbid+'.map.clean.pdb'),
                               'select ftmap_clusters, crosscluster*',
                               'show sticks, ftmap_clusters',
                               'orient receptor',
                               'pseudoatom receptor_label, receptor_bb; label receptor_label, "receptor"',
                               'pseudoatom peptide_label, peptide; label peptide_label, "peptide"',
                               ''])

################################################################################
################################################################################
################################################################################
    
    
def filter_chain_eq(chain_constraint):
    return (lambda atom: atom.chain_id == chain_constraint)

def filter_atom_type(type_constraint):
    return (lambda atom: atom.type == type_constraint)

def filter_bfactor_gt(bfactor_cutoff):
    return (lambda atom: atom.bfactor >= bfactor_cutoff)

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
    
def bfactor(atom):
    return atom.bfactor
    
def get_peptide_atoms(filename):
    pdb_lines = open(filename, 'r')
    peptide_filters = [filter_chain_eq(CHAIN_PEPTIDE),
                       filter_atom_type(PEPTIDE_ATOM_TYPE), ]
    peptide_atoms = get_atoms(pdb_lines, peptide_filters)
    pdb_lines.close()
    return peptide_atoms

def get_receptor_atoms(filename, bfactor_threshold= -np.Inf):
    pdb_lines = open(filename, 'r')
    binder_filters = [filter_chain_eq(CHAIN_RECEPTOR),
                      filter_atom_type(RECEPTOR_ATOM_TYPE),
                      filter_bfactor_gt(B_FACTOR_CUTOFF), ]
    binders = get_atoms(pdb_lines, binder_filters)
    pdb_lines.close()
    return binders

def get_receptor_surface_atoms(filename):
    pdb_lines = open(filename, 'r')
    surface_filters = [filter_chain_eq(CHAIN_RECEPTOR),
                      filter_atom_type(RECEPTOR_ATOM_TYPE),
                      filter_bfactor_gt(0), ]
    surface_atoms = get_atoms(pdb_lines, surface_filters)
    pdb_lines.close()
    return surface_atoms

################################################################################

def centroid(residue_atoms, atom_weights=None):
    assert atom_weights is None or (atom_weights.ndim == 1 and len(atom_weights) == len(residue_atoms))
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
        residue_atoms = [atom for atom in all_receptor_atoms if atom.res_num == center_atom.res_num]
        # add a weight function for atom types here
        residue_atom_weights = None
        (center_atom.pos.x, center_atom.pos.y, center_atom.pos.z) = centroid(residue_atoms, residue_atom_weights)
    return center_atoms

def weighted_centroid(atoms):
    assert type(atoms) is list or type(atoms) is np.array
    coords = np.array([[atom.pos.x, atom.pos.y, atom.pos.z] for atom in atoms])
    weights = np.array([atom.bfactor for atom in atoms ])
    return np.average(coords, 0, weights)

def weighted_pdist(coords, weights=None):
    pdistances = pdist(coords, metric=CLUSTERING_METRIC)
    if weights is not None:
        # Weighting the distance matrix by pairwise weight product
        assert (type(weights) is np.ndarray) and len(weights.shape) <= 2 and max(weights.shape) == coords.shape[0]
        weight_matrix = np.power(np.outer(weights , weights), -0.5)
        pdistances = squareform(np.multiply(squareform(pdistances), weight_matrix))
    return pdistances

def weighted_cdist(coords1, coords2, weights1=None, weights2=None):
    cdistances = cdist(coords1, coords2, metric=CLUSTERING_METRIC)
    if weights1 is not None and weights2 is not None:
        assert (type(weights1) is np.ndarray) and len(weights1.shape) <= 2 and max(weights1.shape) == coords1.shape[0]
        assert (type(weights2) is np.ndarray) and len(weights2.shape) <= 2 and max(weights2.shape) == coords2.shape[0]
        weight_matrix = np.power(np.outer(weights1 , weights2), -0.5)
        assert cdistances.shape == weight_matrix.shape
        cdistances = np.multiply(cdistances, weight_matrix)
    return cdistances

################################################################################

def spatial_clustering_degree(atoms, weights_vector):
    coords_matrix = np.array(map(coords, atoms))
    distances = weighted_pdist(coords_matrix, weights_vector)
#    print len(atoms)
    score = np.power(distances, -1).sum() * np.power(float(len(atoms)), -2)
    return float(score)


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

    pdistances = weighted_pdist(coords_matrix, bfactor_vector)
    logging.debug('DISTANCE MATRIX:\n' + str(pdistances))

    Z = linkage(pdistances, method=CLUSTERING_METHOD, metric=CLUSTERING_METRIC)
    flat_clusters = fcluster(Z, t=CLUSTER_DIAMETER_CUTOFF, criterion=CLUSTERING_CRITERION)
    
    assert(len(flat_clusters) == coords_matrix.shape[0])
    logging.debug('FLAT CLUSTERS:\n' + str(flat_clusters))
    return flat_clusters

################################################################################

def cluster_coords_distances(cluster1_coords, cluster2_coords, cluster1_weights=None, cluster2_weights=None):
    return np.sort(weighted_cdist(cluster1_coords, cluster2_coords, cluster1_weights, cluster2_weights), axis=None)

def find_linkable_clusters(clusters_list):
    cluster_coords = [np.array([coords(atom) for atom in cluster])  for cluster in clusters_list]
#    cluster_weights = [np.array([atom.bfactor for atom in cluster]) for cluster in clusters_list]
    min_distance = np.Inf
    neighbor_clusters = None
    dij = None
    for i in range(len(clusters_list)):
        for j in range(i + 1, len(clusters_list)):
            dij = cluster_coords_distances(cluster_coords[i], cluster_coords[j],)
#                                          cluster_weights[i], cluster_weights[j])
            #if  dij < min_distance:
            if (np.all(dij[:4] < options.neighbor_distance_cutoff)):
                min_distance = dij[0]
                neighbor_clusters = (clusters_list[i], clusters_list[j])
    assert min_distance > 0
    return neighbor_clusters

def cluster_scoring_function(cluster_atoms):
    cluster_bfactors = np.array(map(bfactor, cluster_atoms))
    return spatial_clustering_degree(cluster_atoms, weights_vector=cluster_bfactors)

def write_pymol_script(output_stream, clusters):
    print >> output_stream, 'color white, receptor'
    for cluster in clusters:
        if clusters.index(cluster) >= len(COLORS):
            logging.debug('out of colors - too many clusters!')
            break
        cluster_num = clusters.index(cluster,)
        cluster_ca_object = 'cluster%d_ca' % cluster_num
        cluster_res_object = 'cluster%d_%s' % (cluster_num, COLORS[cluster_num])
        cluster_resnum_str = re.sub(r'[\[\] ]', '', str(sorted([atom.res_num for atom in cluster])))
        print >> output_stream, 'select %s, receptor and name %s and (resi %s); deselect' % (cluster_ca_object, RECEPTOR_ATOM_TYPE, cluster_resnum_str)
        print >> output_stream, 'select %s, br. %s; deselect' % (cluster_res_object, cluster_ca_object)
        print >> output_stream, 'delete %s' % (cluster_ca_object)
        print >> output_stream, 'color %s, %s' % (COLORS[cluster_num], cluster_res_object)
        print >> output_stream, 'set transparency, 0.1, cluster*'
    
    # visualize fpockets:
    import shutil
    tmp_pockets_lib='/vol/ek/assaff/workspace/peptalk/data/peptiDB/unbound/fpocket/%s' % pymol_pdbid
    tmp_pockets_lib = '/tmp/fpocket_test_%d' % os.getpid()
    if not os.path.exists(tmp_pockets_lib):
        subprocess.Popen(['fpocket','-f', options.pdbfilename, options.fpocket], stdout=open(os.devnull)).communicate()
        print ' '.join(['fpocket','-f', options.pdbfilename, options.fpocket])   
        orig_pockets_lib=os.path.abspath(options.pdbfilename[:-4]+'_out')
        shutil.move(orig_pockets_lib, tmp_pockets_lib)
    pocket_pdbs = glob(tmp_pockets_lib+'/pockets/pocket*.pqr')
#    fpocket_out_pdb = os.path.join()
    for pocket_pdb in pocket_pdbs[:5]:
        pocket_number = pocket_pdbs.index(pocket_pdb)
        pocket_object = 'pocket%d_%s' % (pocket_number, COLORS[pocket_number]) 
        print >> output_stream, 'load %s, %s' % (pocket_pdb, pocket_object)
        print >> output_stream, 'hide everything, %s' % (pocket_object)
        print >> output_stream, 'alter %s, vdw=vdw+1.4' % (pocket_object)
        print >> output_stream, 'show surface, %s' % pocket_object
        print >> output_stream, 'color %s, %s' % (COLORS[pocket_number], pocket_object)
        print >> output_stream, 'set transparency, 0.5, %s' % pocket_object

    # visualize conservation
    consurf_dir='/vol/ek/assaff/workspace/peptalk/data/peptiDB/unbound/ConSurfAnalysis/data'
    consurf_data_file = os.path.join(consurf_dir, pymol_pdbid, 'pdbFILE_view_ConSurf.pdb')
    consurf_object = 'consurf_data'
    # find surface residues, save them in 'exposed' object.
    print >> output_stream, 'load %s, %s' % (consurf_data_file, consurf_object)
    print >> output_stream, 'run /a/warhol-00/h/miro/ek/assaff/workspace/peptalk/src/analysis/findSurfaceResidues.py'
    print >> output_stream, 'findSurfaceResidues %s' % consurf_object
    print >> output_stream, 'hide everything, %s' % consurf_object
    print >> output_stream, 'select conserved_ca, br. %s and (b > 7) and exposed and name ca' % consurf_object
    print >> output_stream, 'show spheres, conserved_ca; color purple, conserved_ca; deselect'  
    
    print >> output_stream, 'orient receptor'
    return
    
def color_by_closeness(network_threshold):        
    from Bio.PDB import PDBParser, PDBIO
    p = PDBParser()
    filename = os.path.abspath(options.pdbfilename)
    s_tmp = p.get_structure(id='2CCH', file=filename)
    receptor_res = [res for res in s_tmp.get_residues() if res.get_parent().get_id()==CHAIN_RECEPTOR]
    old_bfactors = np.array([res['CA'].get_bfactor() for res in receptor_res], float)
#        print len(receptor_res)
#        receptor_atoms = [res['CA'] for res in receptor_res]
    coords_matrix = np.array([res['CA'].get_coord() for res in receptor_res], float)
    surface_graph = nx.Graph()
    adj_matrix = 1*(cdist(coords_matrix, coords_matrix) <= network_threshold)
    for i in range(adj_matrix.shape[0]):
        for j in range(adj_matrix.shape[1]):
            if adj_matrix[i,j]==1:
                surface_graph.add_edge(receptor_res[i], receptor_res[j])
#        import matplotlib.pyplot as plt
#        nx.draw_spectral(surface_graph)
#        plt.show()
    new_bfactors = np.zeros_like(old_bfactors)
    for res, cc in nx.closeness_centrality(surface_graph).items():
        new_bfactors[receptor_res.index(res)] = cc
    print old_bfactors[:5]
    print new_bfactors[:5]
    for res in receptor_res:
        for atom in res.get_list():
            atom.set_bfactor(new_bfactors[receptor_res.index(res)])
    io = PDBIO()
    io.set_structure(s_tmp)
    io.save(filename)

def visualize(clusters):
#        assert not options.pymol_output.startswith('/dev'), 'Cannot read from %s' % options.pymol_output
    TEMP_PML_FILENAME = '/tmp/temp%d_visualize.pml' % os.getpid()
    TEMP_PML = open(TEMP_PML_FILENAME, 'w')
    print >> TEMP_PML, DEFAULT_PYMOL_INIT
    write_pymol_script(TEMP_PML, clusters)
    TEMP_PML.close()
    SINK = open('/dev/null')
    subprocess.Popen(['pymol', '-qd', '@%s' % TEMP_PML_FILENAME, ], stdout=SINK, stderr=SINK)
    SINK.close()
#        os.remove(TEMP_PML_FILENAME)

def report(clusters, clusters_confidence):
    CLUSTERS_OUT = open(options.output_clustering_report, 'w')
    print >> CLUSTERS_OUT, '# Clustering parameters'
    for param, value in options.__dict__.items():
        print >> CLUSTERS_OUT, '# %s\t=\t%s' % (param, str(value))
    print >> CLUSTERS_OUT, '#' + ('\t'.join(['PDB', 'RANK', 'SIZE', 'CONFD', 'RESIDUES']))
    for cluster in clusters:
        cluster.sort(key=lambda x: x.res_num)
        cluster_index = clusters.index(cluster)
        cluster_res_str = ','.join([str(atom.res_num) for atom in cluster])
        print >> CLUSTERS_OUT, '\t'.join([PDB_ID,
                                          str(cluster_index),
                                          str(len(cluster)),
                                          '%.3f' % clusters_confidence[cluster_index],
                                          cluster_res_str])
    CLUSTERS_OUT.close()

def script(clusters):
    PYMOL_SCRIPT = open(options.output_pymol_script, 'w')
    print >> PYMOL_SCRIPT, DEFAULT_PYMOL_INIT
    write_pymol_script(PYMOL_SCRIPT, clusters)
    PYMOL_SCRIPT.close()

def session(clusters):
    TEMP_PML_FILENAME = '/tmp/temp.%d.pml' % os.getpid()
    TEMP_PML = open(TEMP_PML_FILENAME, 'w')
    print >> TEMP_PML, DEFAULT_PYMOL_INIT
    write_pymol_script(TEMP_PML, clusters)
    print >> TEMP_PML, 'save %s; quit;' % (options.output_pymol_session)
    TEMP_PML.close()
    SINK = open('/dev/null')
    subprocess.Popen(['pymol', '-qcd', '@%s' % TEMP_PML_FILENAME, ], stdout=SINK, stderr=SINK)
    SINK.close()


################################################################################
################################################################################
#                                MAIN
################################################################################
################################################################################


if __name__ == '__main__':

    classified_pdb_filename = os.path.abspath(options.pdbfilename)

    pdb_atoms = get_receptor_atoms(classified_pdb_filename, B_FACTOR_CUTOFF)
    if options.use_centroid:
        pdb_atoms = shift_coords_to_centroids(pdb_atoms, pdbfilename=classified_pdb_filename)

    logging.debug('Receptor "positive" CA atoms:')
    for atom in pdb_atoms: logging.debug(atom.pdb_str())
    
    coords_matrix = np.array([coords(atom) for atom in pdb_atoms])
    assert coords_matrix.shape[0] == len(pdb_atoms)

    weights = None
    if options.weight_by_bfactor:
#        print >> sys.stderr, 'WARNING: weighting residues pairwise distance by their confidence (svm classification).'
        weights = np.array([atom.bfactor for atom in pdb_atoms])
    cluster_assignment = weighted_fclusterdata(coords_matrix, weights)

    clusters = [[atom for atom in pdb_atoms if cluster_assignment[pdb_atoms.index(atom)] == cluster_num] for cluster_num in set(cluster_assignment)]

    if options.connect_neighbor_clusters:
        #while np.all(min_distance < options.neighbor_distance_cutoff):
        while True:
            neighbors = find_linkable_clusters(clusters)
            if neighbors is None:
                break
            clusters.remove(neighbors[0])
            clusters.remove(neighbors[1])
            clusters.insert(0, neighbors[0] + neighbors[1])

    clusters = filter(lambda cluster: len(cluster) > 3, clusters)
    
    clusters_confidence = map(cluster_scoring_function, clusters)
    clusters.sort(key=cluster_scoring_function, reverse=True)
    
################################################################################
#                                OUTPUT
################################################################################
    
    NETWORK_THRESHOLD = 8.0 # angstroms,
    if options.closeness:
        color_by_closeness(NETWORK_THRESHOLD)

    if options.visualize:
        visualize(clusters)

    if options.output_clustering_report:
        report(clusters, clusters_confidence)

    if options.output_pymol_script:
        script(clusters)

    if options.output_pymol_session:
        session(clusters)

    logging.shutdown()
    exit()
