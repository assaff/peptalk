load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1CZY.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 21,22,22,23,24,24,25,156,158,160); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 42,43,44,44,45,58,59,60,60,61,77,78,79,81,97,114,114,115,116,117,117,120,122,123,126,130,130,131,132,132,133,133,134,134); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 10,11,13,13,14,15,45,46,46,47,58); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 100,101,102,103,104,104,109,109,110,150,151,153,158); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
select cluster4_ca, receptor and name CB and (resi 27,28,153,154,154,155,155,156); deselect
select cluster4_green, br. cluster4_ca; deselect
delete cluster4_ca
color green, cluster4_green
