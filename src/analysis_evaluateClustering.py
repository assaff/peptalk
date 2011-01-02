#!/usr/bin/python
'''
Created on Dec 25, 2010

@author: assaf
'''

import os, re, sys
sys.path.append(os.path.abspath('./match'))
from itertools import chain

from molecule import Atom, AtomFromPdbLine
from polymer import Polymer

#BASE_DIR=os.path.abspath(os.path.join(sys.argv[0],'..'))
#SVM_RESULTS_DIR = os.path.join(BASE_DIR, 'svm_results')
#CONFIG='b0.6_d10.0_c7.0'
#if sys.argv[2]: CONFIG=sys.argv[2]
#CLUSTERING_RESULTS_DIR=os.path.join(BASE_DIR, 'clustering_results', CONFIG)
#ANALYSIS_DIR = os.path.join(BASE_DIR, 'analysis', CONFIG)
#BINDING_DIR=os.path.join(SVM_RESULTS_DIR, 'BindingResidues')
#SURFACE_DIR=os.path.join(SVM_RESULTS_DIR,'SurfaceResidues')
#OUTPUT_PREFIX = ANALYSIS_DIR

class PDBStats():
    '''
    classdocs
    '''
    pdb_id = None
    pdb_filename = None
    polymer_obj = None
    chain_id = None
    length = None
    surface_residues = []
    binding_residues = []
    clusters = {}
    true_binders = {}

    def __init__(self, pdb_filename, pdb_id=None, surface_file=None, binders_file=None, clusters_report_file=None):
        '''
        Constructor
        '''
        assert os.path.isfile(pdb_filename)
        self.pdb_filename = os.path.abspath(pdb_filename)
        pdblines = open(self.pdb_filename).readlines()
        self.receptor_tmp_file = '/tmp/%d.pdb.tmp' % os.getpid()
#        print 'using receptor in %s' % self.receptor_tmp_file
        TMP_PDB = open(self.receptor_tmp_file, 'w')
        for line in pdblines:
            line = line.strip()
            if line.startswith('ATOM') and line[21].strip() == 'A': print >> TMP_PDB, line.strip()
        TMP_PDB.close()
        
        self.pdb_id = os.path.basename(self.pdb_filename).split('.')[0].upper()
        assert re.match(r'^[A-Za-z0-9]{4}$', self.pdb_id)
        self.polymer_obj = Polymer(self.receptor_tmp_file)
        if surface_file:
            self.surface_residues = set(chain.from_iterable([self.residues_with_num(int(line.split()[1])) for line in open(surface_file).readlines()]))
        if binders_file:
            self.binding_residues = set(chain.from_iterable([self.residues_with_num(int(line.split()[1])) for line in open(binders_file).readlines()]))
        if clusters_report_file:
            for line in open(clusters_report_file).readlines():
                if line.startswith('#'): continue
                line_split = line.split()
                cluster_num = int(line_split[1])
                cluster_residues = set(self.residues_with_num(map(int, line_split[-1].split(','))))
                self.clusters[cluster_num] = cluster_residues
                if binders_file:
                    self.true_binders[cluster_num] = cluster_residues.intersection(self.binding_residues)
    
    def residues_with_num(self, residue_nums):
        if type(residue_nums) == int: residue_nums = [residue_nums]
        return [residue for residue in self.polymer_obj._residues if residue.num in residue_nums]
                
    def evaluate_clustering(self, output_filename):    
    #    print resnums(model_data.surface_residues)
    #    print resnums(model_data.binding_residues)
    #    print 'True binders:', resnums(model_data.binding_residues)
    #    print 'Best cluster:', resnums(model_data.clusters[0])
#        binders = self.binding_residues
#        surface = self.surface_residues
#        best_cluster = self.clusters[0]
        total_clustered = set(chain.from_iterable(self.clusters.values()))
#        total_true_binders = total_clustered.intersection(model_data.binding_residues)
        def lens(l): return str(len(l)) # string of length
#        stats_line_format = '\t'.join(['PDB','NUM_BINDING','NUM_CLUSTER','NUM_INTERSECT','TOTAL_CLUSTERED','TOTAL_SURFACE',])
#        stats_line = '\t'.join([model_data.pdb_id, lens(binders), lens(best_cluster), lens(true_binders),lens(total_clustered), lens(surface)])
#        print stats_line
        PDB_ANALYSIS = open(output_filename, 'w')
        print >> PDB_ANALYSIS, '#' + '\t'.join(['PDB', 'RANK', 'SIZE', 'NUM_BINDING', '%_OF_BINDING'])
        for num, cluster in sorted(self.clusters.items(), key=lambda x: x[0]):
            if len(self.binding_residues) == 0: break
            cluster_binding = cluster.intersection(self.binding_residues)
            print >> PDB_ANALYSIS, '\t'.join([self.pdb_id, str(num), lens(cluster), lens(cluster_binding), '%.2f' % (100*len(cluster_binding) / float(len(self.binding_residues)))])
        PDB_ANALYSIS.close()

def resnums(residues):
    return sorted([residue.num for residue in residues])

#def extend_residues(model, residues, t):
#    return set(model.residues_with_num(extend_kernels(resnums(residues), len(model.polymer_obj._residues), t=t)))

def isf(filename):
    return os.path.isfile(filename)

#def extend_kernels(int_list, max_value, t=1):
#    expansion = list(chain.from_iterable([range(i-t,i+t+1) for i in int_list]))
#    expansion = filter(lambda x: x>=0 and x<=max_value, expansion)
#    return set(expansion)
    

def gather_all_stats(pdb_id=None, pdb_filename=None):
    if pdb_id is None and pdb_filename is None: return
    if pdb_filename is None:
        pdb_id = pdb_id.upper()
        pdb_filename = os.path.join(SVM_RESULTS_DIR, '.'.join([pdb_id, 'results', 'pdb']))
    else:
        pdb_id = os.path.basename(pdb_filename).split('.')[0].upper() 
    surface_file = os.path.join(SURFACE_DIR, '%s.unbound.res' % pdb_id)
    binders_file = os.path.join(BINDING_DIR, '%s.res' % pdb_id)
    cluster_file = os.path.join(CLUSTERING_RESULTS_DIR, '%s_%s.clusters.txt' % (pdb_id, CONFIG))
#    print pdb_filename, surface_file, binders_file, cluster_file
    assert isf(pdb_filename)
    assert isf(surface_file)
    assert isf(binders_file)
    assert isf(cluster_file)
    model_data = PDBStats(pdb_filename=pdb_filename, surface_file=surface_file, binders_file=binders_file, clusters_file=cluster_file)
    return model_data

if __name__ == '__main__':
    model_data = None
    if re.match('^[A-Za-z0-9]{4}$', sys.argv[1]):
        model_data = gather_all_stats(pdb_id=sys.argv[1])
    else:
        model_data = gather_all_stats(pdb_filename=sys.argv[1])
