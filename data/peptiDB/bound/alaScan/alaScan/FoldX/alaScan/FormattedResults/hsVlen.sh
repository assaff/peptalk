#!/bin/csh

set thresh=$1
set file=$2

foreach i (`cat /vol/ek/londonir/CleanPeptiDB/db/idlist`)
set len=`grep $i $file | wc -l`
grep $i $file | awk 'BEGIN{hs=0}{if ($NF>'$thresh') hs=hs+1;}END{print '$len',hs}'
end
