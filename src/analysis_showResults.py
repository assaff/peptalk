#!/usr/bin/python

'''
Created on Dec 4, 2010

@author: assaf

'''
VERSION_STRING = '%s v0.0.1, process SVM classification of PDB residues.'

import os, sys, re, logging, subprocess, re
sys.path.append('./match')

import numpy as np
from optparse import OptionParser
from molecule import AtomFromPdbLine, Atom

#from cluster_residues import get_receptor_atoms, get_peptide_atoms

CHAIN_RECEPTOR = 'A'
CHAIN_PEPTIDE = 'B'
RECEPTOR_ATOM_TYPE = 'CA'
PEPTIDE_ATOM_TYPE = 'CA'
BOUND=0
UNBOUND=1
#input_modes = ['bound', 'unbound']

parser = OptionParser(version=VERSION_STRING)
parser.set_defaults(verbose=True)
parser.add_option('-p', '--input-pdb',
                  help='input PDB file to add scoring to',)
parser.add_option('-s', '--input-scores',
#                  default=None,
                  help='input scores file',)
parser.add_option('-o', '--output-pdb',
                  default=None,
                  help='output PDB with scores as bfactor',)
parser.add_option('-P','--peptide-pdb',
                  help='input PDB file from which to get peptide coordinates')
parser.add_option('-w','--write-positives',
                  default=None,
                  help='write positive binding residues to a file')
#parser.add_option('-m','--mode',
#                  help='the mode of the pdb input file [bound/unbound]')

(options, args) = parser.parse_args()

assert options.input_pdb is not None, 'Please supply a valid PDB file as argument.'
#assert options.mode in input_modes, 'Mode argument must be either bound or unbound'


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
    
def get_peptide_atoms(filename):
    pdb_lines = open(filename, 'r')
    peptide_filters = [filter_chain_eq(CHAIN_PEPTIDE),
#                       filter_atom_type(PEPTIDE_ATOM_TYPE),
                       ]
    peptide_atoms = get_atoms(pdb_lines, peptide_filters)
    pdb_lines.close()
    return peptide_atoms

def get_receptor_atoms(filename, bfactor_threshold=-np.Inf):
    pdb_lines = open(filename, 'r')
    receptor_filters = [filter_chain_eq(CHAIN_RECEPTOR),
#                      filter_atom_type(RECEPTOR_ATOM_TYPE),
                      ]
    receptor_atoms = get_atoms(pdb_lines, receptor_filters)
    pdb_lines.close()
    return receptor_atoms



#def get_atoms(pdb_lines, filters=None):
#    receptor_atoms = sorted([AtomFromPdbLine(line) for line in pdb_lines if line.startswith('ATOM')], key=lambda x: x.num)
#    return receptor_atoms

receptor_atoms = get_receptor_atoms(options.input_pdb)
peptide_atoms = get_peptide_atoms(options.peptide_pdb)

score_lines = open(options.input_scores)
scores = dict(sorted([(int(line.split()[1]), float(line.split()[2])) for line in score_lines], key=lambda x: x[0]))
score_lines.close()

def truncate_classification_score(score):
    assert type(score) == float, 'classification score should be a float'
    if score < 0:
        return -1.0
#    elif score > 1.0:
#        return 1
    else:
        return score
    
for atom in receptor_atoms:
    try:
        atom.bfactor = truncate_classification_score(scores[atom.res_num])
#        print atom.res_type, atom.res_num, atom.bfactor
    except KeyError:
        atom.bfactor = 0

for atom in peptide_atoms:
    atom.bfactor = 0
    
model_atoms = receptor_atoms + peptide_atoms


# output the new pdb
output_stream = sys.stdout
if options.output_pdb:
    output_stream = open(options.output_pdb, 'w')
for atom in model_atoms:
    print >> output_stream, atom.pdb_str()
output_stream.close()

if options.write_positives:
#    binder_carbons=[]
    fd = open(options.write_positives, 'w')
    for atom in receptor_atoms:
        try:
            if atom.type=='CA':
                scores[atom.res_num]
                print >> fd, '%s %d %.3f' % (atom.res_type.upper(), atom.res_num, atom.bfactor)
    #            binder_carbons.append(atom)
        except KeyError: pass
    fd.close()


