#!/bin/bash

classifier_dir=/home/assaf/workspace/peptalk/classifier1_full
cluster_script=/home/assaf/workspace/peptalk/src/cluster_residues.py

echo "Clustering structures:"
for BB in `seq 0.5 0.5 1`
do
	for CC in `seq 6 8`
	do
		cd $classifier_dir
		config="b$BB"_"c$CC".0
		echo -n "CONFIG $config: "
		cluster_results_dir=$classifier_dir/clustering_results/$config
		mkdir -p $cluster_results_dir
		for pdb in $classifier_dir/SVMResultsTest/????.results.pdb
		do
			pdb_base=`basename $pdb`
			echo -n "${pdb_base%%.*} "
			python $cluster_script -p $pdb -CSk -c $CC -b $BB -R $cluster_results_dir
		done
		echo ""
		#exit
	done
done
