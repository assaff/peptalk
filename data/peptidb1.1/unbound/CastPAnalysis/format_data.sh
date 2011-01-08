#!/bin/bash


pdbid () {
  raw=$2
  id=${raw%.*}
  echo $id
}

jobid () {
  echo $1
}

while read line;
do

pdb=`pdbid $line`
job=`jobid $line`
#cp $job.tar.gz $pdb.tar.gz
mkdir -p $pdb

cd $pdb
#tar zxvf ../$pdb.tar.gz

for file in $pdb/uploads/*
do
    ext=${file##*.}
    mv $file $pdb/$pdb.$ext
done

cd ..

done < ../joblist.clean

