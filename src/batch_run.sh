#!/bin/bash

for CC in `seq 6 8`
do
for BB in `seq 0.4 0.2 0.8`
do
for pdb in ../data/????.results.pdb
do
echo cluster_residues.py -p $pdb -b $BB -CBSk -c $CC
cluster_residues.py -p $pdb -b $BB -CBSk -c $CC
done
done
done

