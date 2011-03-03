#!/bin/bash

echo -en "# RES\tREAL\tBS_SIZE\t"
head -1 1AWR.clusters.quality.txt
for p in $(cat ../pdb_list.txt); do
f=$p.clusters.quality.txt; 
egrep -v '^#' $f | head -3 \
| awk '{OFS='\t'}END{FS="\t"; ratio=($3/($4+$5+$6+$7));\
 realratio=($4+$7)/($4+$5+$6+$7); if (realratio > ratio+0.05) \
 printf( "%.3f\t%.3f\t%d\t%s\n", ratio, realratio, $4+$7, $0)}'
done | sort -nrk1
