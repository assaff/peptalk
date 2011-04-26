#!/bin/bash

# purpose: to compare results from CASTp to fPocket
# preconditions: get 2p54 results (plain pdb) from CASTp (email)
#                for the same structure, calculate pockets locally with fpocket


cleanup() {
    rm -rf $1*
}

makePymolScript() {
local pdbid=$1
        echo -e \
"load $pdbid.pdb; 
"$(for f in $(ls $pdbid.pock*.pdb); do echo "load $f;"; done)" 
select fpk, $pdbid.pock*.fpo*;
select cstp, $pdbid.pock*.cast*;
cmd.color(\"grey80\",\"$pdbid\");
deselect;
load ../../data/peptiDB/bound/boundSet/$pdbid.pdb, bound; 
select peptide, bound and not chain A;
cmd.color(\"magenta\",'peptide');
cmd.extract(None,\"peptide\",zoom=0);
cmd.show_as(\"cartoon\"   ,\"all\");
cmd.disable('bound');
cmd.spectrum(\"b\",selection=(\"fpk\"),quiet=0);
cmd.spectrum(\"b\",selection=(\"cstp\"),quiet=0);
cmd.show_as(\"spheres\"   ,\"fpk\");
cmd.show_as(\"mesh\"      ,\"cstp\");" \
 > $pdbid.fpk.cstp.pml
}

MAX_POCKET_DEPTH=4

# cleanup
#selfname=$(basename $0)
#cp $selfname ..
#mv ../$selfname .

#castp_pdbs=$(ls -d /vol/ek/assaff/workspace/peptalk/data/peptiDB/unbound/CastPAnalysis/CastPData/???? | cut -c 79-82); cat $castp_pdbs

#cat ../summaryTable_reduced.txt | grep 'IN_BIGGEST' | cut -d' ' -f1 > biggestPocket.pdb_list.txt; cat biggestPocket.pdb_list.txt
for pdbcode in "$@"; do 
    
    cleanup $pdbcode
    
    #unzip castpcalculation.zip
    castp_dir="/vol/ek/assaff/workspace/peptalk/data/peptiDB/unbound/CastPAnalysis/CastPData/$pdbcode/"
    if [ ! -d $castp_dir ]; then
        cleanup $pdbcode
        echo "# $pdbcode insufficient CASTp data"
        continue
    fi
    cp $castp_dir/* .
    cat $pdbcode.pocInfo | sort -nrk7 | nl -pv 0 | awk '{print $1,$4;}' > $pdbcode.vol_sa.pocRank
    cat $pdbcode.poc | grep '^ATOM' | awk '{print $6,$12}' > $pdbcode.resPocMap

    fpocket -f $pdbcode.pdb > /dev/null 2>&1
    pockets_dir=$pdbcode"_out"/pockets
    if [[ $(ls $pockets_dir) == "" ]]; then
        cleanup $pdbcode
        echo "# $pdbcode insufficient Fpocket data"
        continue
    fi

    
    POCKET_DEPTH=$MAX_POCKET_DEPTH
    FPOCKETS_DEPTH=$(( $(ls $pockets_dir/*pdb | wc -l) -1))
    
    if [[ $FPOCKETS_DEPTH -lt $POCKET_DEPTH ]]; then
        POCKET_DEPTH=$FPOCKETS_DEPTH
    fi
    
    for i in $(seq 0 $POCKET_DEPTH); do 

        # fpocket per-pocket residue numbers
        fpocket_resimap=resi_poc$i.$pdbcode.fpocket.txt;
        pocfile=$pdbcode"_out/pockets/pocket$i"_atm.pdb; 
        cat $pocfile | grep -E '^ATOM' | awk '{print $6,$4;}' | sort -un> $fpocket_resimap; 

        # castp per-pocket residue numbers
        # get the pocket ID (assigned by CASTp) that is ranked #i
        castp_resimap=resi_poc$i.$pdbcode.castp.txt;
        pocId=$(grep --max-count=1 -e "^$i" $pdbcode.vol_sa.pocRank | cut -d' ' -f2)
        # now grep the poc file for residue numbers assigned to that pocket
        cat $pdbcode.poc | grep '^ATOM' | grep -e "$pocId  POC" | awk '{print $6,$4}' | sort -un > $castp_resimap

        cat $pdbcode.poc | grep '^ATOM' | grep -e "$pocId  POC" | sed -r "s/.....  ($pocId  POC)/ $i     \1/" > $pdbcode.pocket$i.castp.pdb
        cat $pdbcode"_out"/pockets/pocket$i"_atm.pdb" | grep '^ATOM' | sed -r "s/(.{60})/\1 $i/" > $pdbcode.pocket$i.fpocket.pdb
    done
    
    # analyze recall and precision, crossing all top pockets
    for i in $(seq 0 $POCKET_DEPTH); do
        for j in $(seq 0 $POCKET_DEPTH); do
            fpocket_resimap=resi_poc$i.$pdbcode.fpocket.txt;
            castp_resimap=resi_poc$j.$pdbcode.castp.txt;
            
            tp=$(join -1 1 -2 1 --nocheck-order $castp_resimap $fpocket_resimap | wc -l)
            tpfp=$(wc -l $castp_resimap)
            
            recall=$(calc $tp/$tpfp)
            echo -e "$pdbcode\tf$i,c$j\t$recall" >> fpk.cst.recall.$pdbcode.txt
        done
    done
    sort -nrk3 fpk.cst.recall.$pdbcode.txt | head -1
    makePymolScript $pdbcode
    
done #fpocket.vs.castp.recall.csv

