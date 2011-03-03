#!/bin/bash

source topK.sh

resultsDir=$1
for k in `seq 1 3`; do
    outfile="$resultsDir/roc.top$k.clusters.txt"
    cat /dev/null > $outfile
    echo $outfile
    echo -e "#PDB\tTPR\tFPR\tF1\tDDG_REC\tBS_RTIO\tRL_RTIO\tSURFACE_SZ" >> $outfile
    for f in $resultsDir/*.clusters.quality.txt; do
        topK $f $k >> $outfile
#	    filename=`basename $f`
#	    pdbid=${filename%%.*}
#
#        binders=`cat $f | egrep -v '^#' | head -1 | awk '{print ($4+$7);}'`
#        nonbinders=`cat $f | egrep -v '^#' | head -1 | awk '{print ($5+$6);}'`
#
#	    tp=`cat $f | egrep -v '^#' | head -$k | awk '{sum=sum+$4}END{print sum}'`
#        fp=`cat $f | egrep -v '^#' | head -$k | awk '{sum=sum+$5}END{print sum}'`
#        tn=$((nonbinders - fp))
#        fn=$((binders - tp))
#        ddg_rec=`cat $f | egrep -v '^#' | head -$k | awk '{sum=sum+$11}END{print sum}'`
#
#        tpr=`calc $tp/\($tp+$fn\)`
#        fpr=`calc $fp/\($fp+$tn\)`
#		f1=`calc 2*$tp/\(2*$tp+$fn+$fp\)`
#		bs_size=$((tp + fp))
#		surface_size=$((binders + nonbinders))
#		real_bs_size=$((tp + fn))
#		bs_ratio=$(calc $bs_size/$surface_size)
#		real_bs_ratio=$(calc $real_bs_size/$surface_size)
#	    echo -e "$pdbid\t$tpr\t$fpr\t$f1\t$ddg_rec\t$bs_ratio\t$real_bs_ratio\t$surface_size" >> $outfile

        #cat $f | head -$k
        #echo -e "$k\t\t\t$tp\t$fp\t$tn\t$fn"
	    #echo -e "$pdbid\t$tpr\t$fpr\t$f1"
    done
done


