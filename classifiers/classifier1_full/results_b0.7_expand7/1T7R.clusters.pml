load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1T7R.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 9,12,13,13,14,14,17,43,44,45,46,46,47,48,48,50,51,52,52,57,60,62,63,64,65,65,66,66,67,68,69,70,70,71,73,137,230,234); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 41,224,225,226,226,227,228,229,229,230,233); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 2,3,3,5,6,168,169,172,172,173); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 21,22,22,26,26,27); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
