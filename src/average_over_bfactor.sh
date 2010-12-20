#!/bin/bash

datafile=/home/assaf/workspace/peptalk/analysis/bfactor_diameter_scd.regular.tab
for b in `seq 0.3 0.05 0.85`
do
	for d in `seq 4 0.5 23.5`
	do
		echo -n "$b	$d	"
		cat $datafile | awk -v bfactor=$b -v diameter=$d '{if ($2==bfactor) {sum=sum+$4; i=i+1}} END {print sum/i;}'
	done
done 