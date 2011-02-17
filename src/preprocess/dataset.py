from Bio.PDB.PDBParser import PDBParser

__author__ = 'assaff'

class DataSet:
    '''
        Describes a data set of protein structures.
        '''

    def __init__(self, *args, **kwargs):
        self.name = kwargs.name
        self.id = kwargs.id

a = PDBParser()
a.get_structure(id='3kze',file='3kze.pdb')

print a.trailer

