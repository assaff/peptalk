#!/usr/bin/python

'''
Created on Dec 4, 2010

@author: assaf

'''
VERSION_STRING = '%s v0.0.1, an atom clustering script for molecular structures.'

import os, sys, re, logging, subprocess, re
import numpy as np
from optparse import OptionParser

from molecule import AtomFromPdbLine, Atom

parser = OptionParser(version=VERSION_STRING)
parser.set_defaults(verbose=True)
parser.add_option('-p', '--input-pdb',
                  help='input PDB file to add scoring to',)
parser.add_option('-s', '--input-scores',
                  default=None,
                  help='input scores file',)
parser.add_option('-o', '--output-pdb',
                  default='/dev/fd/0',
                  help='output PDB with scores as bfactor',)

(options, args) = parser.parse_args()

assert options.input_pdb is not None, 'Please supply a valid PDB file as argument.'

def get_atoms(pdb_lines, filters=None):
    atoms = sorted([AtomFromPdbLine(line) for line in pdb_lines if line.startswith('ATOM')], key=lambda x: x.num)
    return atoms

input_lines = open(options.input_pdb)
atoms = get_atoms(input_lines)
input_lines.close()

score_lines = open(options.input_scores)
scores = dict(sorted([(int(line.split()[1]), float(line.split()[2])) for line in score_lines], key=lambda x: x[0]))
score_lines.close()
for atom in atoms:
    try:
        atom.bfactor = scores[atom.res_num]
    except KeyError:
        atom.bfactor = 0


# output the new pdb
output_stream = open(options.output_pdb, 'w')
for atom in atoms:
    if atom.chain_id == 'B': continue
    print >> output_stream, atom.pdb_str()
output_stream.close()


