#!/bin/bash

resultsDir=$1
outfile="$resultsDir/roc.best.clusters.txt"
cat /dev/null > $outfile
echo -e "#PDB\tTPR\tFPR" >> $outfile
for f in $resultsDir/*quality.txt; do
	filename=`basename $f`
    pdbid=${filename%%.*}

    tpr=`cat $f | egrep -v '^#' | sort -nrk 8 | head -1 | cut -f8`
	fpr=`cat $f | egrep -v '^#' | sort -nrk 8 | head -1 | cut -f9`

	#echo -e "$pdbid\t$tpr\t$fpr"
    echo -e "$pdbid\t$tpr\t$fpr" >> $outfile
done

