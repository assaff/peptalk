load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1HC9.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 4,5,6,6,7,11,25,26,27,27,28,29,30,30,31,32,33,36,36,38,38,39,39,40,40,41,41,42,56,67,68,68,69,69,70,70); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 20,45,46,46,47,47,48); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 2,14,15,15,16,17,17,20,44); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 1,2,62,63,63,65,67,73,73); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
