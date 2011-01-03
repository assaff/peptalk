load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1MFG.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 9,11,14,14,15,15,17,17,18,18,19,19,20,20,28,29,37,38,39,40,40,41,42,43,47,48,52,53,53,54,54,56,58,61,71,74,75,75,77,78,78,79,79,81,85); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 7,8,8,9,48,49,50,50,51,51,52); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 91,92,92,93,94,94,95,95); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 59,60,60,61,62,62,65,65,66,67,69,81,85,87,88); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
