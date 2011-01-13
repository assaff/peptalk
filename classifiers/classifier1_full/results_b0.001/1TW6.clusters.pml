load /home/assaf/workspace/peptalk/classifiers/classifier1_full/results_b0.001/1TW6.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 2,4,5,9,10,12,27,30,33,39,44,46,50,51,54,55,56,57,58,61,62,66,69,70,72,75,79,81,90,92,93,94,95); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 19,22); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
