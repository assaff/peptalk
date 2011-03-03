#!/bin/sh

topK () {
    local base=$(basename $1)
    local group_size=$2
    local pdbid=${base%%.*}

    local binders=$(cat $1 | egrep -v '^#' | head -1 | awk '{print ($4+$7);}')
    local nonbinders=$(cat $1 | egrep -v '^#' | head -1 | awk '{print ($5+$6);}')

    local tp=$(cat $1 | egrep -v '^#' | head -$group_size | awk '{sum=sum+$4}END{print sum}')
    local fp=$(cat $1 | egrep -v '^#' | head -$group_size | awk '{sum=sum+$5}END{print sum}')
    local tn=$((nonbinders - fp))
    local fn=$((binders - tp))
    local ddg_rec=$(cat $1 | egrep -v '^#' | head -$group_size | awk '{sum=sum+$11}END{print sum}')
    
    local tpr=$(calc $tp/\($tp+$fn\))
    local fpr=$(calc $fp/\($fp+$tn\))
    local f1=$(calc 2*$tp/\(2*$tp+$fn+$fp\))
    local bs_size=$((tp + fp))
    local surface_size=$((binders + nonbinders))
    local real_bs_size=$((tp + fn))
    local bs_ratio=$(calc $bs_size/$surface_size)
    local real_bs_ratio=$(calc $real_bs_size/$surface_size)
    echo -e "$pdbid\t$tpr\t$fpr\t$f1\t$ddg_rec\t$bs_ratio\t$real_bs_ratio\t$surface_size"
}