#!/bin/bash

pdbfile=$1

egrep '^ATOM' $pdbfile | egrep '^.{12,}CA' | wc -l