#!/usr/bin/python

'''
Created on Jan 1, 2011
This script runs a PDB ID through the PepTalk post-processing pipeline:
1) getting per-residue scores from SVM classification into a scores file
2) creating a structure file of that receptor, with bfactor as the classification score.
3) clustering that structure file to find high-confidence clusters as binders. output: a cluster report and pymol session
4) only for testing: evaluating the clustering scheme with regard to the actual binders (input: binders file).   
@author: assaf
'''

import subprocess, sys, os
from optparse import OptionParser
from datetime import datetime

from analysis_evaluateClustering import PDBStats

CURRENT_MODULE = sys.argv[0]
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(CURRENT_MODULE), os.pardir))
DEFAULT_DATASET_DIR = os.path.abspath(os.path.join(BASE_DIR, 'data/peptiDB'))
DEFAULT_RECEPTOR_PDB_DIR = os.path.join(DEFAULT_DATASET_DIR, 'bound/boundSet')
DEFAULT_PEPTIDE_PDB_DIR = os.path.join(DEFAULT_DATASET_DIR, 'bound/boundSet')
DEFAULT_SCRIPT_DIR = os.path.join(BASE_DIR, 'src') 

ANALYSIS_GET_SCORES_SCRIPT = os.path.join(DEFAULT_SCRIPT_DIR, 'analysis_getScores.sh')
ANALYSIS_SHOW_RESULTS_SCRIPT = os.path.join(DEFAULT_SCRIPT_DIR, 'analysis_showResults.sh')
ANALYSIS_CLUSTERING_SCRIPT = os.path.join(DEFAULT_SCRIPT_DIR, 'analysis_clusterResidues.sh')
ANALYSIS_EVALUATE_CLUSTERING_SCRIPT = os.path.join(DEFAULT_SCRIPT_DIR, 'analysis_evaluateClustering.sh')

RESULTS_PDB = 'results pdb (with SVM classification as bfactor)'
SCORES = 'scores file'
CLUSTERS_REPORT = 'clustering report'
CLUSTERS_PYMOL_SESSION = 'clustering pymol session (.pse)'
CLUSTERS_PYMOL_SCRIPT = 'clustering pymol script (.pml)'
CLUSTERING_EVAL = 'clustering evaluation report'

extensions = {
              RESULTS_PDB : '.results.pdb',
              SCORES : '.scores',
              CLUSTERS_REPORT : '.clusters.txt',
              CLUSTERS_PYMOL_SESSION : '.clusters.pse',
              CLUSTERS_PYMOL_SCRIPT : '.clusters.pml',
              CLUSTERING_EVAL : '.clusters.quality.txt',
              }

parser = OptionParser()
parser.set_defaults(verbose=True)
parser.add_option('-c', '--classification-file',
                  help='SVMlight classification file (output of svm_classify)')
parser.add_option('-m', '--matrix',
                  help='SVMlight matrix describing the set classified (input of svm_classify)')
parser.add_option('-o', '--output-dir',
                  help='directory in which to dump analysis files',)
parser.add_option('-p','--clustering-options',
                  help='a string of options passed to the clustering scheme',
                  default='-Cwk')
(options, pdb_args) = parser.parse_args()

BINDING_RESIDUES_DIR = os.path.abspath(os.path.join(os.path.dirname(options.classification_file), 'BindingResidues_alaScan'))
SURFACE_RESIDUES_DIR = os.path.abspath(os.path.join(os.path.dirname(options.classification_file), 'SurfaceResidues'))
current_time_str = datetime.now().strftime("%m%d%H%M")
#print current_time_str
RESULTS_DIR = os.path.abspath(os.path.join(os.path.dirname(options.classification_file), 'results_%s' % current_time_str))
if options.output_dir:
    RESULTS_DIR = os.path.abspath(options.output_dir)
try: os.makedirs(RESULTS_DIR)
except OSError: pass # in case the directory exists, it's ok
    
def process_pdb(pdbid=None):
    if pdbid is None: return
    options.pdbid = pdbid.upper()
    receptor_pdb = os.path.join(DEFAULT_RECEPTOR_PDB_DIR, options.pdbid + '.pdb')
    peptide_pdb = os.path.join(DEFAULT_PEPTIDE_PDB_DIR, options.pdbid + '.pdb')
#    assert os.path.isfile(receptor_pdb), 'cannot find receptor PDB structure %s' % receptor_pdb
    
    assert os.path.isfile(options.classification_file)
    assert os.path.isfile(options.matrix)
    
    attach_extension = lambda extension: os.path.join(RESULTS_DIR, options.pdbid + extension)
    output_filenames = dict(zip(extensions.keys(), map(attach_extension, extensions.values())))
    print '%s...\t' % options.pdbid,
    
    try:
        # step 1: score extraction
        scores_stream = open(output_filenames[SCORES], 'w')
        return_code = subprocess.Popen([ANALYSIS_GET_SCORES_SCRIPT, options.pdbid, options.classification_file, options.matrix], stdout=scores_stream).wait()
        scores_stream.close()
        if return_code != 0: exit() 
        
        # step 2: score overlay
        results_pdb_stream = open(output_filenames[RESULTS_PDB], 'w')
        subprocess.Popen(['bash', ANALYSIS_SHOW_RESULTS_SCRIPT,
                          receptor_pdb,
                          output_filenames[SCORES],
                          peptide_pdb], stdout=results_pdb_stream).communicate()
        results_pdb_stream.close()
        
        # step 3: clustering
        clustering_report_file = output_filenames[CLUSTERS_REPORT]
        clustering_pymol_session_file = output_filenames[CLUSTERS_PYMOL_SESSION]
        clustering_pymol_script_file = output_filenames[CLUSTERS_PYMOL_SCRIPT]
        subprocess.Popen(['bash', ANALYSIS_CLUSTERING_SCRIPT,
                          output_filenames[RESULTS_PDB],
                          clustering_report_file,
                          clustering_pymol_session_file,
                          clustering_pymol_script_file,
                          options.clustering_options]).communicate()
    
        # step 4: evaluation
        binding_residues_file = os.path.join(BINDING_RESIDUES_DIR, options.pdbid + '.res')
        surface_residues_file = os.path.join(SURFACE_RESIDUES_DIR, options.pdbid + '.bound.res')
        model_data = PDBStats(pdb_filename=receptor_pdb, pdb_id=options.pdbid, binders_file=binding_residues_file, surface_file=surface_residues_file, clusters_report_file=clustering_report_file)
        model_data.evaluate_clustering(output_filename=output_filenames[CLUSTERING_EVAL])
    except:
        pass

    print 'Done.'

if __name__ == '__main__':
    
    for pdb in pdb_args:
        process_pdb(pdbid=pdb)
    exit()
