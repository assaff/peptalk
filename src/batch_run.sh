#!/bin/bash

classifier_dir=/home/assaf/workspace/peptalk/classifier1_full
cluster_script=/home/assaf/workspace/peptalk/src/cluster_residues.py

cluster_options_base="--use-centroids --save-session --connect-neighbor-clusters --clustering-method=ward"

echo "Clustering structures:"
for BB in `seq 0.1 0.4 0.9`
do
	for CC in `seq 6.0 8.0`
	do
		cd $classifier_dir
		config="b$BB"_"c$CC"
		echo -n "CONFIG $config: "
		cluster_results_dir=$classifier_dir/clustering_results/$config
		mkdir -p $cluster_results_dir
		cluster_options="$cluster_options_base -b $BB -c $CC --clustering-results-dir $cluster_results_dir"
		for pdb in $classifier_dir/SVMResultsTest/????.results.pdb
		do
			pdb_base=`basename $pdb`
			echo -n "${pdb_base%%.*} "
			python $cluster_script -p $pdb $cluster_options
		done
		echo ""
		#exit
	done
done
