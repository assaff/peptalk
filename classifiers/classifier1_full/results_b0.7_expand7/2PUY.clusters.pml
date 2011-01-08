load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/2PUY.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 4,5,5,6,6,8,9,16,16,17,17,18,18,19,19,20,21,21,24,26,26,27,28,29,39,40,40,41,43,44,44,45); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 32,33,33,34,34,35,45,46,47,47,49,50,50,54); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
