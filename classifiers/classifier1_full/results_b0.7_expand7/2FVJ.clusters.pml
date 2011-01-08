load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/2FVJ.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 62,63,66,66,67,69,69,70,73); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 19,67,71,74,76,77,78,78,79,79,80,81,82,82,84,87,87,90,92,92,93,94,95,95,96,96,97,98,99,99,100,103,246,247,247,248,248,249,250,251,252,252,253,253,254,255,257); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 49,53,53,122,123,123,124); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 3,3,4,4,5,8); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
select cluster4_ca, receptor and name CB and (resi 105,151,219,221,222,222,223,224,224,225,226,227,228); deselect
select cluster4_green, br. cluster4_ca; deselect
delete cluster4_ca
color green, cluster4_green
