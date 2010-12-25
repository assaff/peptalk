#!/bin/bash

pdbid=`echo $1 | tr '[a-z]' '[A-Z]'`
pymol -d @$pdbid.results.pml > /dev/null &

