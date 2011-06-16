#!/vol/ek/assaff/python/bin/python

import sys
sys.path.append('~/workspace/peptalk/analysis/castp_robot')

import pymol
from prody import compare, proteins, measure, parsePDB, writePDB
from castp_submit import *
from castp_fetch import *

EMAIL_ADDRESS='assaf.faragy@mail.huji.ac.il'
LOCAL_PDB_DIR='/vol/ek/share/pdbmirror'
proteins.setPDBMirrorPath(LOCAL_PDB_DIR)


'''
purpose: to compare CASTp's pocket volume and SASA measurements to the actual
overlap of such pockets with the peptide in complex.

Process:
    1) input: a bound-unbound receptor pair: <bound_pdb> <bound_chains> <peptide_chain> <unbound_pdb> <unbound_chains>
    2) fetch original PDB files for the pair
    3) align unbound to bound (using pymol for now), save clean PDB files: 
        bound_receptor, unbound_receptor, bound_peptide
    4) submit receptor structures to CASTp, fetch results
    5) filter pockets that are accessible (nmouth > 0 )
    6) output each pocket into a pdb of its own
    7) measure overlap for each pocket, rank them accordingly
    8) output a table where each row is a pocket:
       | p-rank | SASA rank | Volume rank | SASA value | Volume value |
'''
def clean_pair(bound_pdb, bound_chains, peptide_chains, unbound_pdb, unbound_chains):
    # 2
    #bound_pdb_gzfile = fetchPDB(bound_pdb)
    #unbound_pdb_gzfile = fetchPDB(unbound_pdb)

    bound_receptor = parsePDB(bound_pdb, chain=bound_chains+peptide_chains)
    unbound_receptor = parsePDB(unbound_pdb, chain=unbound_chains)
    
    #3
    alignment_results = compare.matchAlign(unbound_receptor, bound_receptor)
    unbound_receptor = alignment_results[0]
    
    writePDB('unb.pdb',unbound_receptor.select('protein')
    writePDB('b.pdb',bound_receptor.select('protein and chain %s' % ' '.join(list(bound_chains))))
    writePDB('p.pdb',bound_receptor.select('protein and chain %s' % peptide_chains))
    

def castp_submit(
    # 4
    submit_pdbfile(

process_pair(sys.argv[1],sys.argv[2],sys.argv[3],sys.argv[4],sys.argv[5],)
