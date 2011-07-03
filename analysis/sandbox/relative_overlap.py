#!/usr/bin/python

import sys, os
import numpy as np
from scipy.spatial.distance import cdist

def coords_from_pdb_line(line):
    x = float(line[30:38])
    y = float(line[38:46])    
    z = float(line[46:54])
    return (x, y, z)
    
def get_coords(filename):
    atom_filter = lambda line: line.startswith('ATOM')
    fd = open(filename)
    coords = np.array(map(coords_from_pdb_line, filter(atom_filter, fd.readlines())))
    fd.close()
    return coords

def pocket_overlap(peptide_filename, pocket_filename):
    pocket_coords = get_coords(pocket_filename)
    peptide_coords = get_coords(peptide_filename)
    cdist_matrix = cdist(pocket_coords, peptide_coords)
    mean_ri = cdist_matrix.min(axis=1).mean()
    assert (mean_ri > 0)
    return (1 + 0.1*pocket_coords.shape[0]) * np.power(mean_ri ,-1)


if __name__=='__main__':
    for pocket_filename in sys.argv[2:]:
        if not os.access(pocket_filename, os.R_OK):
            continue
        print '%s %.3f %s' % (pocket_filename[6:8].strip('_'), pocket_overlap(sys.argv[1], pocket_filename), pocket_filename)
