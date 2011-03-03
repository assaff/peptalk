#!/bin/bash

resultsDir=$1
for k in `seq 1 3`; do
	outfile="$resultsDir/roc.best$k.clusters.txt"
	cat /dev/null > $outfile
	echo -e "#PDB\tTPR\tFPR\tF1\tDDG_REC" >> $outfile
	for f in $resultsDir/*quality.txt; do
		filename=`basename $f`
	    pdbid=${filename%%.*}
	
		tp=`cat $f | egrep -v '^#' | head -$k | sort -nrk 8 | head -1 | cut -f4`
		fp=`cat $f | egrep -v '^#' | head -$k | sort -nrk 8 | head -1 | cut -f5`
		tn=`cat $f | egrep -v '^#' | head -$k | sort -nrk 8 | head -1 | cut -f6`
		fn=`cat $f | egrep -v '^#' | head -$k | sort -nrk 8 | head -1 | cut -f7`
	    
	    tpr=`cat $f | egrep -v '^#' | head -$k | sort -nrk 8 | head -1 | cut -f8`
		fpr=`cat $f | egrep -v '^#' | head -$k | sort -nrk 8 | head -1 | cut -f9`
		f1=`calc 2*$tp/\(2*$tp+$fn+$fp\)`
		ddg_rec=`cat $f | egrep -v '^#' | head -$k | sort -nrk 8 | head -1 | cut -f11`
	
		#echo -e "$pdbid\t$tpr\t$fpr\t$f1\t$ddg_rec"
	    echo -e "$pdbid\t$tpr\t$fpr\t$f1\t$ddg_rec" >> $outfile
	done
done

