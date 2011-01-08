#!/bin/bash

resultsDir=$1
k=$2
echo "# PDB   RECALL   SPECIFICITY"
for f in $resultsDir/*quality.txt; do
	filename=`basename $f`
	pdbid=${filename%%.*}
	
	tp=`cat $f | egrep -v '^#' | head -$k | awk '{sum=sum+$4}END{print sum}'`
	tpfn=`wc -l $resultsDir/../BindingResidues/$pdbid.res | cut -f1`
	tpfp=`cat $f | egrep -v '^#' | head -$k | awk '{sum=sum+$3}END{print sum}'`
	recall=`calc $tp/$tpfn`
	specificity=`calc $tp/$tpfp`
	#echo $coverage $size $tp $tpfp $tpfn
	echo "$pdbid    $recall      $specificity"
done # | awk '{sum=sum+$1;}END{print sum/NR}'
exit 


