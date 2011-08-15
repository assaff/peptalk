#!/usr/bin/python

import sys, os
import numpy as np

def get_coords(filename):
    fd = open(filename)
    pdb_array = [line.split() for line in fd.readlines() if line.startswith('ATOM')]
    fd.close()
    coords = np.array([ map(float, atom[6:9]) for atom in pdb_array])
    return coords

def centroid(atom_coords):
    centroid_coords = np.average(atom_coords, axis=0)
    assert centroid_coords.ndim == 1
    return centroid_coords

def centroid_dist(filename1, filename2):
    centroid1 = centroid(get_coords(filename1))
    centroid2 = centroid(get_coords(filename2))
    return np.linalg.norm(centroid1-centroid2)

if __name__=='__main__':
    for pocket_filename in sys.argv[2:]:
        print '%s %.3f %s' % (pocket_filename[6:8], centroid_dist(sys.argv[1], pocket_filename), pocket_filename)
