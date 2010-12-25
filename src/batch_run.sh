#!/bin/bash

for CC in `seq 6 8`
do
for BB in `seq 0.3 0.3 0.9`
do
for pdb in ../data/????.results.pdb
do
echo cluster_residues.py -p $pdb -b $BB -CBSwk -c $CC
cluster_residues.py -p $pdb -b $BB -CBSwk -c $CC
done
done
done

