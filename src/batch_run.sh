#!/bin/bash

for CC in `seq 6 8`
do
for pdb in ../classifier1_full/SVMResultsTest/????.results.pdb
do
echo cluster_residues.py -p $pdb -CSk -c $CC
cluster_residues.py -p $pdb -CSk -c $CC
done
done
done

