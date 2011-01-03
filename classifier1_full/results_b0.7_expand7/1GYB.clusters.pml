load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1GYB.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 33,34,34,35,36,37,38,38,39,95,97,98,99,100,114,115,116,116,117,118,118,119,119,120,121,121); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 2,2,4,4,6,6,7,9,9,10,12,13,13,14,17,62,64,64,65,65,66,66,67,68,68,69,70,70,71,72,78,79,79,80,81,81,82,83,85,100,102,108,108,109,109,110); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 55,56,56,57,60,86,87,88,88,95); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
