load /home/assaf/workspace/peptalk/classifiers/classifier1_full/results_b0.001/1D4T.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 10,12,13,17,32,35,36,37,50,51,52,53,54,55,66,67,68,69,72,73,74,75,88,91,92,94,95); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 2,3,5,79,81,82,101,104); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
