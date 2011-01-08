load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/2FOJ.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 38,42,46,49,50,50,51,52,67,68,70,84,84,85,86,86,87,87,88,90,91,93,94,94,95,96,96,97,97,99,99,100,100,101,102); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 9,10,10,11,12,12,13,14,14,15,15,16,17,17,18,109,119,120,122,123,124); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 25,26,26,27,27,28,29,34,35,36); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 62,63,132,133,133,135,135); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
