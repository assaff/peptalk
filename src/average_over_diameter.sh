#!/bin/bash

datafile=$1
echo Total data points: `wc -l $datafile` > /dev/fd/2
 
for b in `seq 0.3 0.1 0.8`
do
	for d in `seq 4 1 23`
	do
		echo -n "$b	$d	"
		cat $datafile | awk -v bfactor=$b -v diameter=$d '{if ($3==diameter) {sum=sum+$4; i=i+1}} END {print sum/i;}'
	done
done 