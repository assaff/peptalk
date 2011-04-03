#!/bin/bash

LOCAL_PDB_DIR=/vol/ek/share/pdb

function visualize_data_pair {

    local bound_pdb=$(echo $1 | tr '[A-Z]' '[a-z]')
    local bc=$2
    local unbound_pdb=$(echo $3 | tr '[A-Z]' '[a-z]')
    local ubc=$4


    local pmlfile="$bound_pdb.$unbound_pdb.pml"
    #echo $pmlfile
    rm -f $pmlfile
    touch $pmlfile

    midid_b=${bound_pdb:1:2}
    echo load $LOCAL_PDB_DIR/$midid_b/pdb$bound_pdb.ent.gz, $bound_pdb >> $pmlfile
    echo select bound, $bound_pdb and chain $bc >> $pmlfile

    midid_ub=${unbound_pdb:1:2}
    echo load $LOCAL_PDB_DIR/$midid_ub/pdb$unbound_pdb.ent.gz, $unbound_pdb >> $pmlfile
    echo select unbound, $unbound_pdb and chain $ubc >> $pmlfile

    echo align polymer and name ca and bound, polymer and name ca and unbound, quiet=0, object=\"aln_bound_unbound\", reset=1 >> $pmlfile

    echo select peptide, \($bound_pdb within 8 of unbound\) and not bound >> $pmlfile
    echo deselect >> $pmlfile
    echo color red, peptide >> $pmlfile
    echo color green, bound >> $pmlfile
    echo color blue, unbound >> $pmlfile

    echo show_as cartoon, all >> $pmlfile
#    echo hide everything, not bound and not unbound and not peptide >> $pmlfile
    echo "orient unbound;" >> $pmlfile
    echo "create unb_surface, unbound; color white, unb_surface; set transparency, 0.6, unb_surface; show_as surface, unb_surface; hide everything, unb_surface" >> $pmlfile
    echo "symexp sym, $unbound_pdb, ($unbound_pdb), 5.0" >> $pmlfile
    echo "show_as cartoon, sym*; color white, sym*" >> $pmlfile
    #echo "hide everything, sym*" >> $pmlfile
    echo "select crystal_contacts, br. sym* within 5.0 of unbound; color pink, crystal_contacts; deselect;" >> $pmlfile
        echo "select suspects, unbound within 5.0 of crystal_contacts; deselect; color hotpink, suspects" >> $pmlfile
    echo "center peptide" >> $pmlfile
    
    getPdbLocal $unbound_pdb | grep 'REMARK 350' > $bound_pdb.$unbound_pdb.info
    #pymol -q $pmlfile &
}

IFS=$'\n' 
for line in $(cat ../mapping.clean.txt ); do 
    IFS=$' '
    visualize_data_pair $line
    #break
done
    

