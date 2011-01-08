load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/2HPL.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 6,7,9,10,10,17,18,18,19,21,22,22,23,24,25,26,26,27,27,28,29,30,30,31,34,39,39,40,40,41,42,42,43,44,44,45,47,47,49,50,51,64,74,75,76,93,94,95,97,97,98,98,100,100); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 50,51,54,55,55,56,56,57,61); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
