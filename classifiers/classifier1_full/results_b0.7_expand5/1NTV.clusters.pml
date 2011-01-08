load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand5/1NTV.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 33,34,39,88,88,89,89,91,91,92,92,93,93,94,94,95,95,106,107,108,129,129,133,133,136,136,137,137,139,139,140,140); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 54,54,59,59); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
