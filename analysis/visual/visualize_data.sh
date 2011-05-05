#!/bin/bash

LOCAL_PDB_DIR=/vol/ek/share/pdb

function get_pdb {
    local pdb=$(echo $1 | tr '[A-Z]' '[a-z]')
    local midid=${pdb:1:2}
    zcat $LOCAL_PDB_DIR/$midid/pdb$pdb.ent.gz
}

function view_pdb {
    get_pdb $1 | less
}

function getRemarks {

local pdbid=$1
getPdbLocal $pdbid | grep -e '^REMARK'
}

function visualize_data_pair {

    local bound_pdb=$(echo $1 | tr '[A-Z]' '[a-z]')
    local bc=$2
    local bc_obj=$(echo $bc | sed 's/\(.\)/\1+/g'); bc_obj=${bc_obj%+}

    local unbound_pdb=$(echo $4 | tr '[A-Z]' '[a-z]')
    local ubc=$5
    local ubc_obj=$(echo $ubc | sed 's/\(.\)/\1+/g'); ubc_obj=${ubc_obj%+}

    local pc=$3
    local pc_obj=$(echo $pc | sed 's/\(.\)/\1+/g'); pc_obj=${pc_obj%+}
    
    local bound_pdb_obj=$bound_pdb"_bound"
    local unbound_pdb_obj=$unbound_pdb"_unbound"

    local bound_chain_obj="bound_"$bound_pdb"_"$bc
    local unbound_chain_obj="unbound_"$unbound_pdb"_"$ubc
    local peptide_obj="peptide_"$bound_pdb"_"$pc
    
    #ligand objects
    local bound_lig="ligands_"$bound_pdb
    local unbound_lig="ligands_"$unbound_pdb
    
    local pmlfile="$bound_pdb.$unbound_pdb.pml"
    #echo $pmlfile
    rm -f $pmlfile
    touch $pmlfile

    midid_b=${bound_pdb:1:2}
    #getPdbLocal $bound_pdb > $bound_pdb.pdb
    echo load $LOCAL_PDB_DIR/$midid_b/pdb$bound_pdb.ent.gz, $bound_pdb_obj >> $pmlfile
    echo select $bound_chain_obj, polymer and $bound_pdb_obj and chain $bc_obj >> $pmlfile

    midid_ub=${unbound_pdb:1:2}
    #getPdbLocal $unbound_pdb > $unbound_pdb.pdb
    echo load $LOCAL_PDB_DIR/$midid_ub/pdb$unbound_pdb.ent.gz, $unbound_pdb_obj >> $pmlfile
    echo select $unbound_chain_obj, polymer and $unbound_pdb_obj and chain $ubc_obj >> $pmlfile
    echo align polymer and name ca and $bound_chain_obj, polymer and name ca and $unbound_chain_obj, quiet=0, object=\"aln_bound_unbound\", reset=1 >> $pmlfile

    echo select $peptide_obj, polymer and $bound_pdb_obj and chain $pc_obj >> $pmlfile
    echo deselect >> $pmlfile
    echo color lime, $bound_pdb_obj >> $pmlfile
    echo color forest, $bound_chain_obj >> $pmlfile
    echo color cyan, $unbound_pdb_obj >> $pmlfile
    echo color blue, $unbound_chain_obj >> $pmlfile
    echo color red, $peptide_obj >> $pmlfile

    echo "show_as cartoon, all" >> $pmlfile
#    echo hide everything, not bound and not unbound and not peptide >> $pmlfile
    echo "orient" >> $pmlfile
    echo "show sticks, sc. and $peptide_obj" >> $pmlfile
#    echo "create $unbound_pdb.surface, $unbound_pdb_obj; color white, $unbound_pdb.surface; set transparency, 0.6, $unbound_pdb.surface; show_as surface, $unbound_pdb.surface; hide everything, $unbound_pdb.surface" >> $pmlfile
    echo "symexp unbound_sym, $unbound_pdb_obj, ($unbound_pdb_obj), 5.0" >> $pmlfile
    echo "symexp bound_sym, $bound_pdb_obj, ($bound_pdb_obj), 5.0" >> $pmlfile
    echo "show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*" >> $pmlfile
#    echo "center $peptide_obj" >> $pmlfile

    echo select $bound_lig, $bound_pdb_obj and not polymer and not resn HOH >> $pmlfile
    echo select $unbound_lig, $unbound_pdb_obj and not polymer and not resn HOH >> $pmlfile
    echo "show_as spheres, $bound_lig or $unbound_lig" >> $pmlfile
    #getRemarks $bound_pdb > remarks.$bound_pdb.info
    #getRemarks $unbound_pdb > remarks.$unbound_pdb.info
    
    #pymol -q $pmlfile &
}

function visualize_table {
IFS=$'\n' 
for line in $(cat ../newMapping.csv ); do 
    IFS=$' '
    visualize_data_pair $line
    #break
done
    }

