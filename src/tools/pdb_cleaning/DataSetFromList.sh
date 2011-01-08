#!/usr/bin/tcsh

foreach p ( `cat $1` )
    set id=$p:r
    set chain=$p:e
    /vol/ek/assaff/peptiDB_1.1/tools/pdb_cleaning/getCleanReceptorPdb.sh $id $chain
end

