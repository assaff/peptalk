#!/bin/bash

pdbid=`tr '[a-z]' '[A-Z]' $1`
pymol -d $pdbid.results.pml

