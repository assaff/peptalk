#!/bin/bash

# Author: Assaf Faragy, assaff@cs.huji.ac.il
#
# Input: $1: receptor PDB file
#        $2: peptide PDB file (as ligand)
#
# output to STDOUT: PDB file of complex, where the peptide is described
# as a ligand in HETATM entries with constant residue name.
# This is a prep procedure for pocket evaluation with dpocket.
receptor_pdbfile=$1
peptide_pdbfile=$2

temp_pdb=/tmp/complex2dpocket.tmp.pdb
peptide_resn="PEP"

pymol_seq="

run /vol/ek/assaff/pymol/scripts/zero_residues.py
load $receptor_pdbfile, rec
load $peptide_pdbfile, pep

alter rec, chain=\"A\"
zero_residues rec, 1
alter pep, chain=\"B\"
zero_residues pep, 1
alter pep, type=\"HETATM\"
alter pep, resn=\"$peptide_resn\"

save $temp_pdb, rec or pep
"

#alter pep, name=\"NIL\"
#alter pep, chain=\" \"
pymol -cd "$pymol_seq" > /dev/null

cat $temp_pdb
if [ $? ]; then
    rm $temp_pdb
fi
