#!/bin/bash

resultsDir=$1
cat $resultsDir/*quality.txt| egrep -v '^#' | egrep '^....0' | awk '{sum=sum+$1;}END{print sum/NR}'


