#!/bin/bash

echo "### submit_pdbs.sh - Submission script to FTMap server ###"

echo "$1"

if [[ $1 != "" ]];
then
    #receptors=""
    echo "Command line arguments are currently not supported. Run the script where \`pwd\` contains the desired pdb files, or write this option in the script."
    exit
else
    receptors=`ls ????.?.pdb`
fi

echo "PDB files to submit:"
echo $receptors
echo "#################################"

for receptor in $receptors; do
    echo "Submitting $receptor"
    pdb_chain=${receptor%.*}
    pdb=${pdb_chain%.*}
    chain=${pdb_chain##*.}
    #echo $pdb $chain
    timestamp=$(date +%Y%m%d-%H%M%S)
    submit_command="php ftmap_submit.phar --protein=$receptor --jobname=$pdb.$chain.time$timestamp"
    echo $submit_command
    #`submit_command`
done
