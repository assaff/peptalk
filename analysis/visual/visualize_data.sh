#!/bin/bash

LOCAL_PDB_DIR=/vol/ek/share/pdb
PEPTIDB_TABLE_URL='https://spreadsheets.google.com/pub?hl=en_US&hl=en_US&key=0ApXQ1x_sHoGrdFYwdEJ6aTFZckc3cHlzZEVzV01jUWc&single=true&gid=10&range=A1%3AF300&output=csv'

lowercase() { 
    echo $1 | tr '[A-Z]' '[a-z]'
}

get_pdb() {
    local pdb=$(echo $1 | tr '[A-Z]' '[a-z]')
    local midid=${pdb:1:2}
    zcat $LOCAL_PDB_DIR/$midid/pdb$pdb.ent.gz
}

view_pdb() {
    get_pdb $1 | less
}

getRemarks() {

local pdbid=$1
getPdbLocal $pdbid | grep -e '^REMARK'
}

pymol_chain_str() {
    local tmp=$(echo $1 | sed 's/\(.\)/\1+/g')
    echo ${tmp%+}
}

visualize_data_pair() {

    local bound_pdb=$(lowercase $1)
    local bc=$(lowercase $2)
    local bc_obj=$(pymol_chain_str $bc)

    local unbound_pdb=$(lowercase $4)
    local ubc=$(lowercase $5)
    local ubc_obj=$(pymol_chain_str $ubc)

    local pc=$(lowercase $3)
    local pc_obj=$(pymol_chain_str $pc)
    
    local bound_pdb_obj=$bound_pdb"_bound"
    local unbound_pdb_obj=$unbound_pdb"_unbound"

    local bound_chain_obj="bound_"$bound_pdb"_"$bc
    local unbound_chain_obj="unbound_"$unbound_pdb"_"$ubc
    local peptide_obj="peptide_"$bound_pdb"_"$pc
    
    #ligand objects
    local bound_lig="ligands_"$bound_pdb
    local unbound_lig="ligands_"$unbound_pdb
    
    local pmlfile="$bound_pdb.$bc.$pc.$unbound_pdb.$ubc.pml"
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
    
    #echo $pmlfile
    #pymol -q $pmlfile &
}

visualize_pockets() {

    # general names
    local bound_pdb=$(lowercase $1)
    local bc=$(lowercase $2)
    local bc_obj=$(echo $bc | sed 's/\(.\)/\1+/g'); bc_obj=${bc_obj%+}

    local pc=$(lowercase $3)
    local pc_obj=$(echo $pc | sed 's/\(.\)/\1+/g'); pc_obj=${pc_obj%+}
    
    local unbound_pdb=$(lowercase $4)
    local ubc=$(lowercase $5)
    local ubc_obj=$(echo $ubc | sed 's/\(.\)/\1+/g'); ubc_obj=${ubc_obj%+}
    
    visualize_data_pair $bound_pdb $bc $unbound_pdb $ubc $pc

    local pair_id="$bound_pdb.$bc.$pc.$unbound_pdb.$ubc"

    # pymol objects
    local bound_pdb_obj=$bound_pdb"_bound"
    local unbound_pdb_obj=$unbound_pdb"_unbound"

    local bound_chain_obj="bound_"$bound_pdb"_"$bc
    local unbound_chain_obj="unbound_"$unbound_pdb"_"$ubc
    local peptide_obj="peptide_"$bound_pdb"_"$pc
    
        # ligand objects
    local bound_lig="ligands_"$bound_pdb
    local unbound_lig="ligands_"$unbound_pdb
    
    
    #local pockets_dir="$pair_id"
    #mkdir -p $pockets_dir
    #cd $pockets_dir
    
    # pockets analysis
    midid_b=${bound_pdb:1:2}
    zcat $LOCAL_PDB_DIR/$midid_b/pdb$bound_pdb.ent.gz > $bound_pdb.pdb
    midid_ub=${unbound_pdb:1:2}
    zcat $LOCAL_PDB_DIR/$midid_ub/pdb$unbound_pdb.ent.gz > $unbound_pdb.pdb    
    
    local clean_pml="
    
    load $bound_pdb.pdb, $bound_pdb_obj 
    select $bound_chain_obj, polymer and $bound_pdb_obj and chain $bc_obj 
    select $peptide_obj, polymer and $bound_pdb_obj and chain $pc_obj 

    load $unbound_pdb.pdb, $unbound_pdb_obj 
    select $unbound_chain_obj, polymer and $unbound_pdb_obj and chain $ubc_obj 
    align polymer and name ca and $bound_chain_obj, polymer and name ca and $unbound_chain_obj, quiet=0, object=\"aln_bound_unbound\", reset=1 
    deselect 
    
    save $unbound_chain_obj.pdb, $unbound_chain_obj 
    save $bound_chain_obj.pdb, $bound_chain_obj 
    save $peptide_obj.pdb, $peptide_obj 
    quit 
    "
    pymol -cd "$clean_pml" > /dev/null
return
    #describePockets $unbound_chain_obj.pdb $peptide_obj.pdb
#echo "commenting" << COMMENT1
local analysis_name="$unbound_pdb_obj"
local peptide_resn="PEP"

pymol_seq="

load $unbound_chain_obj.pdb, rec
load $peptide_obj.pdb, pep

alter pep, type=\"HETATM\"
alter pep, resn=\"$peptide_resn\"
alter pep, name=\"NIL\"
alter pep, chain=\" \"

save $analysis_name.pdb, rec or pep
"

pymol -cd "$pymol_seq" > /dev/null

fpocket -f $analysis_name.pdb
dpocket_commandfile=/tmp/dpocket_commandfile.txt
echo -e "$analysis_name.pdb\t$peptide_resn" > $dpocket_commandfile
dpocket -f $dpocket_commandfile

headerline=$(head -1 dpout_fpocketp.txt)
all_poc_datafile=dpout_total.txt
echo "#$headerline" > $all_poc_datafile
cat dpout_fpocketp.txt dpout_fpocketnp.txt | grep -v '^pdb' | sort -nk5 >> $all_poc_datafile

cd ..; return
#COMMENT1
    
    # run fpocket on clean unbound pdb
    fpocket -f $unbound_chain_obj.pdb
    local fpocket_dir=$unbound_chain_obj"_out"
    

    local visualize_pml="visualize.pml"
    echo $visualize_pml
    rm -f $visualize_pml
    touch $visualize_pml

    echo load $unbound_chain_obj.pdb >> $visualize_pml
    echo load $peptide_obj.pdb >> $visualize_pml
    
    echo color white, $unbound_chain_obj >> $visualize_pml
    echo color red, $peptide_obj >> $visualize_pml

    echo "show_as cartoon, all" >> $visualize_pml
#    echo hide everything, not bound and not unbound and not peptide >> $visualize_pml
    echo "orient" >> $visualize_pml
    echo "show sticks, $peptide_obj" >> $visualize_pml
    echo "create $unbound_chain_obj.surface, $unbound_chain_obj; color white, $unbound_chain_obj.surface; set transparency, 0.6, $unbound_chain_obj.surface; show_as surface, $unbound_chain_obj.surface; disable $unbound_chain_obj.surface" >> $visualize_pml


    for pocFile in $fpocket_dir/pockets/pocket*vert.pqr; do
        echo load $pocFile, $(basename $pocFile) >> $visualize_pml
        done
    echo alter pocket*, vdw=vdw+1.4 >> $visualize_pml
    echo "show_as mesh, pocket*" >> $visualize_pml
    echo color orange, pocket* >> $visualize_pml

    echo "orient" >> $visualize_pml #echo "center $peptide_obj" >> $visualize_pml
#    pymol -q $visualize_pml &

    
    cd ..; return 0
    
}

describePockets() {

local receptor_pdbfile=$1
local peptide_pdbfile=$2

local analysis_name="dpoc.receptor.peptide"
local peptide_resn="PEP"


pymol_seq="

load $receptor_pdbfile, rec
load $peptide_pdbfile, pep

alter pep, type=\"HETATM\"
alter pep, resn=\"$peptide_resn\"
alter pep, name=\"ASF\"
alter pep, chain=\" \"

save $analysis_name.pdb, rec or pep
"

pymol -cd "$pymol_seq" > /dev/null

fpocket -f $analysis_name.pdb
dpocket_commandfile=/tmp/dpocket_commandfile.txt
echo -e "$analysis_name.pdb\t$peptide_resn" > $dpocket_commandfile
dpocket -f $dpocket_commandfile

headerline=$(head -1 dpout_fpocketp.txt)
all_poc_datafile=dpout_total.txt
echo "#$headerline" > $all_poc_datafile
cat dpout_fpocket*p.txt | grep -v '^pdb' >> $all_poc_datafile
}

visualize_table() {
    
    local tablefile="peptidb_table.csv~"
    wget $PEPTIDB_TABLE_URL -O $tablefile > /dev/null
    if [ ! -e $tablefile ]; then 
        echo "cannot find table online"
        exit 1
    fi
    
    IFS=$'\n' 
    for line in $(cat $tablefile | grep -v '^#' | cut -d',' -f1-5 ); do 
        IFS=$','
        visualize_data_pair $line
        visualize_pockets $line
        #break
    done
    #rm -v $tablefile
}

