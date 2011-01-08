load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand5/3CVP.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 58,62,62,63,63,64,66,83,83,86,86,90,90,94,94,95,95,96,96,145,145,179,179,182,182,183,183,186,186,189,189,190,190,194,197,204,213,213,214,217,217,220,220,221,224,224); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 212,240,240,241,241,243,243,244,244,245,245,246,246,272); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 20,20,25,25,33,36); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 48,77,77,79,79); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
