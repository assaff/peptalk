'''
Created on Dec 25, 2010

@author: assaf
'''

from molecule import Atom, AtomFromPdbLine
from polymer import Polymer

import os, re, sys

class PDBStats():
    '''
    classdocs
    '''
    pdb_id = None
    pdb_filename = None
    chain_id = None
    length = None
    surface_residues = []
    true_binders = []
    clusters = []

    def __init__(self, pdb_filename, surface_file=None, binders_file=None, clusters_file=None):
        '''
        Constructor
        '''
        assert os.path.isfile(pdb_filename)
        self.pdb_filename = pdb_filename
        self.pdb_id = os.path.basename(self.pdb_filename).split('.')[0]
        assert re.match(r'^[A-Za-z0-9]{4}$', self.pdb_id)
        self.polymer_obj = Polymer(self.pdb_filename)
        if surface_file:
            for line in open(surface_file).readlines():
                surface_res_index = int(line.split()[1])
                assert surface_res_index == self.polymer_obj._residues[surface_res_index].num
                self.surface_residues += [self.polymer_obj._residues[surface_res_index]]
        if binders_file:
            for line in open(binders_file).readlines():
                binder_res_index = int(line.split()[1])
                assert binder_res_index == self.polymer_obj._residues[binder_res_index].num
                self.true_binders += [self.polymer_obj._residues[binder_res_index]]
        if clusters_file:
            for line in open(clusters_file).readlines():
                line_split = line.split()
                cluster_num = int(line_split[0])
                cluster_residues = [self.polymer_obj._residues[res_num] for res_num in [int(num) for num in line_split[1:]]]

def gather_all_stats(basepath='/home/assaf/workspace/peptalk'):
    