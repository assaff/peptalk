#!/bin/bash

pdb_id=`echo $1 | tr '[a-z]' '[A-Z]'`
classification_file=$2
matrix_file=$3
tmp_matrix_file="/tmp/svmMatrix_$pdb_id.$$.tmp"
egrep -v '^#' $matrix_file > $tmp_matrix_file

if [ `cat  $classification_file | wc -l` != `cat $tmp_matrix_file | wc -l` ]
then
	echo "Are you sure the classification file and matrix match? They should have the same number of lines (non commented). Now exiting."
	exit
fi

results=`egrep $pdb_id $tmp_matrix_file`
if [ "$results" ]; then
	paste $tmp_matrix_file $classification_file | egrep $pdb_id | cut -d' ' -f11,12 | sed 's/\(...\)\(.*\)/\1 \2/'
	exit 0
fi
exit 1
		
#rm -f $tmp_matrix_file
#exit 0
#echo "paste $tmp_matrix_file $classification_file | awk '{print \$(NF-2),\$(NF-1),\$(NF)}' | grep $pdb_id"
#paste $tmp_matrix_file $classification_file | egrep $pdb_id | awk '{print $(NF-1)," ",$NF;}' | sed 's/\(...\)\(.*\)/\1 \2/' 