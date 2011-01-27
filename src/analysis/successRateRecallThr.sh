#!/bin/bash

tprThreshold=$1

totalSamples=0
succesSamples=0

verbose=""

for p in `cat ../pdb_list.txt`; do  

    let totalSamples++
    f=$p.clusters.quality.txt
    let maxrecall=0
    
    maxTpr=`for k in $(seq 1 5); do \
                egrep -v '^#' $f | head -$k | awk '{if ($3/($4+$5+$6+$7) < 0.3 || ($4+$5+$6+$7) < 50) print $8}'; done | sort -nrk1 | head -1`
    source $HOME/bin/float.sh
    if float_cond "$maxTpr>$tprThreshold"; then
        let succesSamples++
        if [ $verbose ]; then echo "$p success"; fi
    else
        if [ $verbose ]; then echo "$p fail"; fi
    fi
    
done

echo -e "$tprThreshold\t$(float_eval "100*$succesSamples/$totalSamples")"
