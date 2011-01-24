#!/bin/bash

resultsDir=$1
for k in `seq 1 8`; do
    outfile="$resultsDir/roc.top$k.clusters.txt"
    cat /dev/null > $outfile
    echo -e "#PDB\tTPR\tFPR" >> $outfile
    for f in $resultsDir/*.clusters.quality.txt; do
	    filename=`basename $f`
	    pdbid=${filename%%.*}

        binders=`cat $f | egrep -v '^#' | head -1 | awk '{print ($4+$7);}'`
        nonbinders=`cat $f | egrep -v '^#' | head -1 | awk '{print ($5+$6);}'`
	
	    tp=`cat $f | egrep -v '^#' | head -$k | awk '{sum=sum+$4}END{print sum}'`
        fp=`cat $f | egrep -v '^#' | head -$k | awk '{sum=sum+$5}END{print sum}'`
        tn=$((nonbinders - fp))
        fn=$((binders - tp))
        
        tpr=`calc $tp/\($tp+$fn\)`
        fpr=`calc $fp/\($fp+$tn\)`

	    echo -e "$pdbid\t$tpr\t$fpr" >> $outfile
        #cat $f | head -$k
        #echo -e "$k\t\t\t$tp\t$fp\t$tn\t$fn"
	    #echo -e "$pdbid\t$tpr\t$fpr"
    done
done


