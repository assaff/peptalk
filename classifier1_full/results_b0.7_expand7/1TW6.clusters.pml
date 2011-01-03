load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1TW6.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 4,9,10,10,13,14,24,26,27,27,28,30,30,31,32,33,33,34,36,37,38,39,39,43,44,44,45,46,46,47,49,50,50,51,51,54,54,55,55,56,56,57,57,58,58,61,61,62,62,63,64,65,66,66,67,69,70,70,71,74,76); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 2,2,4,5,5,48,49); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
