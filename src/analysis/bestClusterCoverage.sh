#!/bin/bash

resultsDir=$1
cat $resultsDir/*quality.txt| egrep -v '^#' | egrep '^.....0' | awk '{sum=sum+$NF;}END{print sum/NR}'


