load /home/assaf/workspace/peptalk/classifiers/classifier1_full/results_b0.7/1NTV.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 88,89,91,92,93,94,95,129,133,136,137,139,140); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 54,59); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
