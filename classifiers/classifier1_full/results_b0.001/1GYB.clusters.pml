load /home/assaf/workspace/peptalk/classifiers/classifier1_full/results_b0.001/1GYB.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 2,4,6,9,12,13,64,65,66,68,70,71,72,79,81,108,109); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 19,34,38,39,56,58,61,88,95,116,118,119,120,121); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
