#!/usr/bin/tcsh

set script_dir=`/vol/ek/assaff/peptiDB_1.1/tools/pdb_cleaning`
set pdbid=`sh $script_dir/capitalize.sh $1`
set chain=`sh $script_dir/capitalize.sh $2`

echo $pdbid $chain
exit

perl /vol/ek/share/rosetta/pdbUtil/getPdb.pl -id $pdbid
set downloaded=`echo $pdbid.pdb | tr '[A-Z]' '[a-z]'`
set tmpfile=rcsb.tmp.pdb

perl /vol/ek/assaff/scripts/extract_chains_and_range.pl -p $downloaded -c $chain -o $tmpfile >! /dev/null

# renumber residues to start with 1
set pdbfile=$pdbid.$chain.pdb
perl /vol/ek/share/rosetta/pdbUtil/sequentialPdbResSeq.pl -pdbfile $tmpfile -res1 1 >! $pdbfile

rm -f $tmpfile
rm -f $downloaded

echo "Clean, single chain model: $pdbfile"
