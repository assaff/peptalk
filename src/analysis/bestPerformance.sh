#!/bin/bash

source topK.sh

resultsDir=$1
for k in `seq 1 8`; do
	outfile="$resultsDir/roc.bestOf$k.clusters.txt"
	cat /dev/null > $outfile
    echo $outfile
    echo -e "#PDB\tTPR\tFPR\tF1\tDDG_REC\tBS_RTIO\tRL_RTIO\tSURFACE_SZ" >> $outfile
    for f in $resultsDir/*quality.txt; do
		base=$(basename $f)
		tmpfile=/tmp/$base
		egrep -v '^#' $f | head -$k | sort -nrk 8 > $tmpfile
		topK $tmpfile 1 >> $outfile
#	    rm $tmpfile
	done
	
done

