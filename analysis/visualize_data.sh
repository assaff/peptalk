#!/bin/bash

function get_pdb {
pdbid=$1
mid=${1:1:2}
zcat -v /vol/ek/share/pdb/$mid/pdb$pdbid.ent.gz > $pdbid.pdb
}



b=$(echo $1 | tr '[A-Z]' '[a-z]')
bc=$2
ub=$(echo $3 | tr '[A-Z]' '[a-z]')
ubc=$4
f=$b.$ub

echo $b $bc $ub $ubc

get_pdb $b
get_pdb $ub

pmlfile=$f.pml
rm -f $pmlfile
touch $pmlfile
exit

echo load $b.pdb >> $pmlfile
echo select bound, $b and chain $bc >> $pmlfile

echo load $ub.pdb >> $pmlfile
echo select unbound, $ub and chain $ubc >> $pmlfile

echo align polymer and name ca and unbound, polymer and name ca and bound, quiet=0, object=\"aln_bound_unbound\", reset=1 >> $pmlfile

echo select peptide, \($b within 8 of unbound\) and not bound >> $pmlfile
echo deselect >> $pmlfile
echo color magenta, peptide >> $pmlfile

echo show_as cartoon, all >> $pmlfile
echo hide everything, not bound and not unbound and not peptide >> $pmlfile
echo orient peptide >> $pmlfile

# pymol -q $pmlfile &

