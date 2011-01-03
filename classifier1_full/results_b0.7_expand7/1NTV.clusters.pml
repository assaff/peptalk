load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1NTV.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 33,34,39,72,86,87,88,88,89,89,90,91,91,92,92,93,93,94,94,95,95,96,104,106,107,108,125,126,128,129,129,130,132,133,133,134,135,136,136,137,137,138,139,139,140,140,141,142,144,148); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 50,51,53,54,54,55,58,59,59,60); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
