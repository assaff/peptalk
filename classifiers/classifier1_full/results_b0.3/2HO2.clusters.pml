load /home/assaf/workspace/peptalk/classifiers/classifier1_full/results_b0.3/2HO2.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 9,12,16,17,19,22,23,25,26,27,28,29,30); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 1,4,5); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
