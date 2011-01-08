load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/2HO2.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 3,7,8,9,9,10,12,12,16,16,17,17,18,19,19,20,21,25,26,26,27,27,28,28,29); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 3,4,4,5,5,7,31); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
