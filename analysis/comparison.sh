#!/bin/csh

set f=$1
set pmlfile=$f.comparison.pml
rm -f $pmlfile
touch $pmlfile

echo load /vol/ek/dattias/PeptideDocking/PlacementProtocol/unbound/unboundSet/$f.pdb, $f.unbound >> $pmlfile
echo select receptor, $f.unbound and chain A >> $pmlfile
echo show_as cartoon, receptor >> $pmlfile
echo color white, receptor >> $pmlfile


echo load /vol/ek/londonir/CleanPeptiDB/db/$f.pdb, $f.bound >> $pmlfile
echo select peptide, $f.bound and chain B >> $pmlfile
echo show_as sticks, peptide >> $pmlfile
echo color yellow, peptide >> $pmlfile
echo hide everything, $f.bound and not peptide >> $pmlfile

#echo show lines >> $pmlfile
#echo select chain A and $f.bound >> $pmlfile
#echo show cartoon, sele >> $pmlfile
#echo select chain B and $f.bound >> $pmlfile
#echo color cyan, sele >> $pmlfile
#echo show_as sticks, sele >> $pmlfile
#echo select $f.unbound >> $pmlfile
#echo color green, sele >> $pmlfile
#echo show cartoon, sele >> $pmlfile
echo load /vol/ek/dattias/PeptideDocking/PlacementProtocol/unbound/FTMapAnalysis/ftmapData/$f.map.pdb >> $pmlfile
#echo load /vol/ek/londonir/CleanPeptiDB/analysis/soaking/bound/$f.map.pdb >> $pmlfile
echo select protein >> $pmlfile
echo hide everything, sele >> $pmlfile

echo orient receptor >> $pmlfile
echo deselect >> $pmlfile

echo create receptor_surf, receptor >> $pmlfile
echo show surface, receptor_surf >> $pmlfile


