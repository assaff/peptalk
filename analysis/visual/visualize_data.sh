#!/bin/bash

function get_pdb {
local pdbid=$(echo $1 | tr '[A-Z]' '[a-z]')
local mid=${pdbid:1:2}
/usr/bin/rsync -rlpt -v -z --delete --port=873 rsync.ebi.ac.uk::pub/databases/rcsb/pdb-remediated/data/structures/divided/pdb/$mid/pdb$pdbid.ent.gz .
#zcat -v /vol/ek/share/pdb/$mid/pdb$pdbid.ent.gz > $pdbid.pdb
zcat -v pdb$pdbid.ent.gz > $pdbid.pdb
rm -f pdb$pdbid.ent.gz
}

function visualize_data_pair {

    local bound_pdb=$(echo $1 | tr '[A-Z]' '[a-z]')
    local bc=$2
    local unbound_pdb=$(echo $3 | tr '[A-Z]' '[a-z]')
    local ubc=$4

#    get_pdb $bound_pdb
#    get_pdb $unbound_pdb

    local pmlfile="$bound_pdb.$unbound_pdb.pml"
    echo $pmlfile
    rm -f $pmlfile
    touch $pmlfile

    echo load $bound_pdb.pdb >> $pmlfile
    echo select bound, $bound_pdb and chain $bc >> $pmlfile

    echo load $unbound_pdb.pdb >> $pmlfile
    echo select unbound, $unbound_pdb and chain $ubc >> $pmlfile

    echo align polymer and name ca and unbound, polymer and name ca and bound, quiet=0, object=\"aln_bound_unbound\", reset=1 >> $pmlfile

    echo select peptide, \($bound_pdb within 8 of unbound\) and not bound >> $pmlfile
    echo deselect >> $pmlfile
    echo color magenta, peptide >> $pmlfile
    echo color yellow, bound >> $pmlfile
    echo color blue, unbound >> $pmlfile

    echo show_as cartoon, all >> $pmlfile
#    echo hide everything, not bound and not unbound and not peptide >> $pmlfile
    echo orient bound >> $pmlfile
    echo "create unb_surface, unbound; color white, unb_surface; set transparency, 0.6, unb_surface; show_as surface, unb_surface;" >> $pmlfile
#    pymol -q $pmlfile &
}

IFS=$'\n' 
for line in $(cat ../mapping.clean.txt ); do 
    IFS=$' '
    visualize_data_pair $line
    #break
done
    

