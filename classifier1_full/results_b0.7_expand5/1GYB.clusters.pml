load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand5/1GYB.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 34,34,36,38,38,100,116,116,118,118,119,119,121,121); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 2,2,4,4,6,6,9,9,13,13,64,64,65,65,66,66,68,68,70,70,72,79,79,81,81,83,108,108,109,109); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 56,56,57,88,88); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
