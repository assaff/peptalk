#!/bin/bash

resultsDir=$1
k=$2
for f in $resultsDir/*quality.txt; do 
	cat $f | egrep -v '^#' | head -$k | awk '{sum=sum+$NF}END{print sum}';
done | awk '{sum=sum+$1;}END{print sum/NR}'


