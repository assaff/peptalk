#!/bin/bash

resultsDir=$1
for k in `seq 1 8`; do
    outfile="$resultsDir/roc.top$k.clusters.txt"
    cat /dev/null > $outfile
    echo -e "#PDB\tTPR\tFPR" >> $outfile
    for f in $resultsDir/*quality.txt; do
	    filename=`basename $f`
	    pdbid=${filename%%.*}
	
	    tp=`cat $f | egrep -v '^#' | head -$k | awk '{sum=sum+$4}END{print sum}'`
        fp=`cat $f | egrep -v '^#' | head -$k | awk '{sum=sum+$5}END{print sum}'`
        tn=`cat $f | egrep -v '^#' | head -$k | awk '{sum=sum+$6}END{print sum}'`
        fn=`cat $f | egrep -v '^#' | head -$k | awk '{sum=sum+$7}END{print sum}'`
        tpr=`calc $tp/\($tp+$fn\)`
        fpr=`calc $fp/\($fp+$tn\)`
	    #recall=`calc $tp/$tpfn`
	    #specificity=`calc $tp/$tpfp`
	    #echo $coverage $size $tp $tpfp $tpfn
	    #echo -e "$pdbid\t$tpr\t$fpr"
	    echo -e "$pdbid\t$tpr\t$fpr" >> $outfile
    done # | awk '{sum=sum+$1;}END{print sum/NR}'
done
exit

