load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1AWR.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 52,53,54,54,55,56,57,59,59,60,61,62,76,80,81,81,82,86,87,87,89,90,90,91,92,92,96,98,99,100,101,101,102,102,105,106,106,107,111,112,112,113,114,115,116,118,121,121,122,122,124,125,125,126,127); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 36,37,39,40,40,42,42); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 28,29,29,31,32,33,84,85,85,86,126); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
