#!/usr/bin/python
'''
Created on Dec 25, 2010

@author: assaf
'''

import os, re, sys
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(sys.argv[0]),'match')))
from itertools import chain
import numpy as np

from molecule import Atom, AtomFromPdbLine
from polymer import Polymer

BASE_DIR=os.path.abspath('/vol/ek/assaff/workspace/peptalk')
DATASET_DIR=os.path.abspath(os.path.join(BASE_DIR,'data/peptiDB'))
CLASSIFIER_DIR = os.path.join(BASE_DIR, 'classifiers/classifier1_full')
#ANALYSIS_DIR = os.path.join(DATASET_DIR, 'analysis', CONFIG)
BINDING_DIR=os.path.join(CLASSIFIER_DIR, 'BindingResidues')
SURFACE_DIR=os.path.join(CLASSIFIER_DIR,'SurfaceResidues')
RESULTS_DIR=os.path.join(CLASSIFIER_DIR,'results_b0.7')
#OUTPUT_PREFIX = ANALYSIS_DIR

def nsorted(unsorted):
    s = sorted([int(item) for item in unsorted])
    return [str(item) for item in s]

def resnums(residues):
    return nsorted([residue.num for residue in residues])

def isf(filename):
    return os.path.isfile(filename)

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
            self.surface_residues = set([self.residue_with_num(int(line.split()[1]))
                                         for line in open(surface_file).readlines()])
        if binders_file:
#            self.binding_residues = set(chain.from_iterable([self.residues_with_num(int(line.split()[1])) for line in open(binders_file).readlines()]))
#            self.alaScan_residues = [(line.split()[0],int(line.split()[1]),float(line.split()[2])) 
#                                     for line in open(binders_file).readlines()]
#            self.binding_ddg        = dict([(int(line.split()[1]), float(line.split()[2]))
#                                            for line in open(binders_file).readlines()])
            self.binding_dict = dict([((self.residue_with_num(int(line.split()[1]))), 
                                       float(line.split()[2]))
                                      for line in open(binders_file).readlines()])
            self.binding_residues   = set(self.binding_dict.keys())
            
        if clusters_report_file:
            for line in open(clusters_report_file).readlines():
                if line.startswith('#'): continue
                line_split = line.split()
                cluster_num = int(line_split[1])
                cluster_residues = set(map(self.residue_with_num, (map(int, line_split[-1].split(',')))))
                self.clusters[cluster_num] = cluster_residues
                if binders_file:
                    self.true_binders[cluster_num] = cluster_residues.intersection(self.binding_residues)
    
#    def residues_with_num(self, residue_nums):
#        assert type(residue_nums) == list
#        return map(self.residue_with_num, residue_nums)
    
    def residue_with_num(self, residue_num):
        assert type(residue_num) == int
#        print residue_num, self.polymer_obj.n_residue()
        residues = [res for res in self.polymer_obj._residues if res.num==residue_num]
        assert len(residues)==1
        res = residues[0]
        assert res.num == residue_num, '%d\t%d' %(residue_num, res.num)
        return res
                
    def evaluate_clustering(self, output_filename):    
        binders = self.binding_residues
        nonbinders = self.surface_residues.difference(self.binding_residues)
        total_ddg_array = np.array(self.binding_dict.values())
        
#        dbg_arr = np.array([self.binding_dict[resi] for resi in binders])
#        assert np.equal(total_ddg_array.sum(),dbg_arr.sum()), '%f\t%f'%(total_ddg_array.sum(), dbg_arr.sum())
#        try: assert np.all(total_ddg_array == np.array([self.binding_dict[resi] for resi in binders]))
#        except: print total_ddg_array; print dbg_arr; raise
        
        PDB_ANALYSIS = open(output_filename, 'w')
        print >> PDB_ANALYSIS, '#' + '\t'.join(['PDB', 'RANK', 'SIZE', 'TP','FP','TN','FN','TPR','FPR','F1','DDG_RCL','CLUSTER_RESIDUES'])
        for cluster_rank, cluster in sorted(self.clusters.items(), key=lambda x: x[0]):
            if len(self.binding_residues) == 0: break
            
            tp=binders.intersection(cluster)
            fp=cluster.difference(binders)
            tn=nonbinders.difference(cluster)
            fn=binders.difference(cluster)
            
            tp_num = len(tp)
            fp_num = len(fp)
            tn_num = len(tn)
            fn_num = len(fn)
            
            assert tp_num+fp_num==len(cluster)
            assert tp_num+fn_num==len(binders)
                        
            tpr = float(tp_num)/float(tp_num+fn_num)
            fpr = float(fp_num)/float(fp_num+tn_num)
            f1 = 2*float(tp_num)/float(2*tp_num+fn_num+fp_num)
            
            cluster_ddg_array = np.array([self.binding_dict[resi] for resi in tp])
            rec_ddg = float(cluster_ddg_array.sum()) / float(total_ddg_array.sum())
            assert rec_ddg <= 1 and rec_ddg >= 0, rec_ddg
#            print rec_ddg
            
            def num_str(num):
                if type(num) is float: return '%.3f'%num
                elif type(num) is int: return str(num)
                else: raise ValueError('please provide either int or float')
            stats_vector = [tp_num, fp_num, tn_num, fn_num, tpr, fpr, f1, rec_ddg] 
            cluster_res_str = ','.join(resnums(cluster))
            cluster_row_list = [self.pdb_id, str(cluster_rank), str(len(cluster))] + map(num_str, stats_vector) + [cluster_res_str]
            
            cluster_row = '\t'.join(cluster_row_list)
            print >> PDB_ANALYSIS, cluster_row
        PDB_ANALYSIS.close()


def gather_all_stats(pdb_id=None, pdb_filename=None):
    if pdb_id is None and pdb_filename is None: raise IOError()
    if pdb_filename is None:
        pdb_id = pdb_id.upper()
        pdb_filename = os.path.join(RESULTS_DIR, '.'.join([pdb_id, 'results', 'pdb']))
    else:
        pdb_id = os.path.basename(pdb_filename).split('.')[0].upper() 
    surface_file = os.path.join(SURFACE_DIR, '%s.bound.res' % pdb_id)
    binders_file = os.path.join(BINDING_DIR, '%s.res' % pdb_id)
    clusters_report_file = os.path.join(RESULTS_DIR, '%s.clusters.txt' % pdb_id)
#    print pdb_filename, surface_file, binders_file, clusters_report_file
    assert isf(surface_file)
    assert isf(binders_file)
    assert isf(pdb_filename)
    assert isf(clusters_report_file)
    model_data = PDBStats(pdb_filename=pdb_filename, pdb_id=pdb_id, surface_file=surface_file, binders_file=binders_file, clusters_report_file=clusters_report_file)
    return model_data

if __name__ == '__main__':
    for pdb in sys.argv[1:]:
        model_data = None
        if re.match('^[A-Za-z0-9]{4}$', sys.argv[1]):
            model_data = gather_all_stats(pdb_id=pdb)
        else:
            model_data = gather_all_stats(pdb_filename=pdb)
        model_data.evaluate_clustering(output_filename='/dev/fd/0')