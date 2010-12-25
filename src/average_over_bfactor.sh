#!/bin/bash

datafile=$1
for b in `seq 0.3 0.1 0.8`
do
	for d in `seq 4 1 23`
	do
		echo -n "$b	$d	"
		cat $datafile | awk -v bfactor=$b -v diameter=$d '{if ($2==bfactor) {sum=sum+$4; i=i+1}} END {print sum/i;}'
	done
done 