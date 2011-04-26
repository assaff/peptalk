#!/bin/bash

# purpose: to compare results from CASTp to fPocket
# preconditions: get 2p54 results (plain pdb) from CASTp (email)
#                for the same structure, calculate pockets locally with fpocket

MAX_POCKET_DEPTH=2

# cleanup
selfname=$(basename $0)
cp $selfname ..
rm -rf *
mv ../$selfname .

castp_pdbs=$(ls -d /vol/ek/assaff/workspace/peptalk/data/peptiDB/unbound/CastPAnalysis/CastPData/???? | cut -c 79-82)

#cat ../summaryTable_reduced.txt | grep 'BIGGEST' | cut -d' ' -f1 > biggestPocket.pdb_list.txt
for pdbcode in $castp_pdbs; do #$(cat biggestPocket.pdb_list.txt); do

    #unzip castpcalculation.zip
    rm -rf $pdbcode*
    cp /vol/ek/assaff/workspace/peptalk/data/peptiDB/unbound/CastPAnalysis/CastPData/$pdbcode/$pdbcode.* .
    [ $? -ne 0 ] && continue

    fpocket -f $pdbcode.pdb > /dev/null

    cat $pdbcode.pocInfo | sort -nrk7 | nl -pv 0 | awk '{print $1,$4;}' > $pdbcode.vol_sa.pocRank
    cat $pdbcode.poc | grep '^ATOM' | awk '{print $6,$12}' > $pdbcode.resPocMap
    
    POCKET_DEPTH=$MAX_POCKET_DEPTH
    FPOCKETS_NUM=$(ls $pdbcode"_out"/pockets/*.pdb | wc -l)
    [ $FPOCKETS_NUM -lt $POCKET_DEPTH ] && POCKET_DEPTH=$FPOCKETS_NUM

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


        echo -e \
"load $pdbcode.pdb; 
"$(for f in $(ls $pdbcode.pock*.pdb); do echo "load $f;"; done)" 
select fpk, $pdbcode.pock*.fpo*;
select cstp, $pdbcode.pock*.cast*;
cmd.color(\"grey80\",\"$pdbcode\");
deselect;
load ../../data/peptiDB/bound/boundSet/$pdbcode.pdb, bound; 
select peptide, bound and not chain A;
cmd.color(\"magenta\",'peptide');
cmd.extract(None,\"peptide\",zoom=0);
cmd.show_as(\"cartoon\"   ,\"all\");
cmd.disable('bound');
cmd.spectrum(\"b\",selection=(\"fpk\"),quiet=0);
cmd.spectrum(\"b\",selection=(\"cstp\"),quiet=0);
cmd.show_as(\"spheres\"   ,\"fpk\");
cmd.show_as(\"mesh\"      ,\"cstp\");" \
 > $pdbcode.fpk.cstp.pml
    

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
    #rm -rf $pdbcode*
done > fpocket.vs.castp.recall.csv

