#!/bin/bash

# 
pdb_filename=$1
pdb_base=$(basename $pdb_filename)
pdb_dir=$(dirname $pdb_filename)
prefix=${pdb_base%%.pdb}
echo $prefix $pdb_base $pdb_filename
pocket_tmpdir=/tmp/castp.$prefix.$$
mkdir -p $pocket_tmpdir

rank=1
for pocId in $(cat $pdb_dir/$prefix.pocInfo | tail -n +2 | sort -nrk 5 | awk '{if ($4>0) print $3}'); do 
    #echo $rank
    cat $pdb_dir/$prefix.pdb | grep -e '^ATOM' | cut -c1-60 > $pocket_tmpdir/$prefix.pdb
    cat $pdb_dir/$prefix.poc | grep '^ATOM' | grep -e " $pocId  POC" | cut -c1-60 | awk -v r="$rank" '{printf "%s %.2f\n",$0,r}' > $pocket_tmpdir/pocket$(printf "%02d" $rank).id$pocId.castp.pdb
    ((rank++))
done

pymol_seq="

load $pocket_tmpdir/$prefix.pdb
select peptide, $prefix and chain B
import glob, cmd
for p in sorted(glob.glob(\"$pocket_tmpdir/pocket*.pdb\")): cmd.load(p)

spectrum b, rainbow
show_as spheres, pocket*

show_as cartoon, $prefix or peptide
color grey, $prefix
color magenta, peptide


orient $prefix
"

pymol -qd "$pymol_seq" $pocket_tmpdir/*pdb > /dev/null &
