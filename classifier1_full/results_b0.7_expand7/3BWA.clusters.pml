load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/3BWA.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 5,6,7,7,8,8,9,24,25,27,27,28,29,30,30,31,32,33,95,96,96,97,98,99,99,113,114,116,117,209,210,211); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 34,45,55,58,58,59,59,60,62,62,63,63,64,66,66,67); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 116,117,118,122,123,123,124,135,136,140,143,143,144,146,147); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
