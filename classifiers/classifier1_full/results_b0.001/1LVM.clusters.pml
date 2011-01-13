load /home/assaf/workspace/peptalk/classifiers/classifier1_full/results_b0.001/1LVM.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 9,10,12,13,46,97,117,119,120,122,123,125,126,127,128,145,146,147,148,151,167,168,169,170,171,172,174,178,207,211,214,215,216,217,218,219,220,221); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 76,78); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 61,64,66,68,88,89,90,92,93); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 2,3,4); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
select cluster4_ca, receptor and name CB and (resi 184,185); deselect
select cluster4_green, br. cluster4_ca; deselect
delete cluster4_ca
color green, cluster4_green
