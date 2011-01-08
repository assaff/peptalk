load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1U00.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 10,11,11,12,13,13,17,33,34,35,35,36,36,37,38,38,39,40,42,42,43,44,45,45,46,46,47,48,50,57,64,65,65,66,67,68,71,76,76,79,80,81,83,97,146,147,150,150,151,153,154,154,155,158); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 92,110,111,111,112,112,113,113,114,114); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 49,50,51,60,61,61,62,63,63,64,110); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 158,162,165,204,205,207,208,208,210,211,211,212,212,213,214,215,216,216,218,219,219,220); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
select cluster4_ca, receptor and name CB and (resi 2,3,3,4,5,5,6,24,25,26,27,121); deselect
select cluster4_green, br. cluster4_ca; deselect
delete cluster4_ca
color green, cluster4_green
select cluster5_ca, receptor and name CB and (resi 29,30,30,32,32,33,82,83,84,85,86); deselect
select cluster5_cyan, br. cluster5_ca; deselect
delete cluster5_ca
color cyan, cluster5_cyan
