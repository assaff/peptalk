#!/bin/zsh
#

cp -r classifier1_full/{BindingResidues_alaScan,SurfaceResidues} .

for id in $(cat pdb_list.txt); do
    for filename in BindingResidues_alaScan/$id.res \
        SurfaceResidues/$id.{bound,unbound}.res; do 
        [ -e $filename ] && echo $filename && cat $filename | LC_ALL=C sort -sk2 | awk -v pdb=$id '{print pdb,$0}' | sponge $filename
    done
done

for id in $(cat pdb_list.txt ); do 
    join -1 3 -2 3 -a 1 -e 0 -o "1.1 1.2 1.3 2.4" \
        SurfaceResidues/$id.bound.res \
        BindingResidues_alaScan/$id.res \
        | sort -nk3 > BindingResidues_alaScan/$id.all.res
done

echo "#PDBID RESNAME RESNUM ALASCAN_DDG" > boundRes.ddg.txt
cat BindingResidues_alaScan/*all.res >> boundRes.ddg.txt
