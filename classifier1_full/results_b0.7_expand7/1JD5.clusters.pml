load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1JD5.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 27,29,46,47,48,50,52,53,53,57,57,58,58,59,59,60,60,61,61,63,64,64,65,65,66,67,68,69,69,70,71,72,73,73,74,74,75,75,76,76,77,78,79,80,89); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 13,13,16,17,33,35,36,36,37); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 2,2,3,3,4,78); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
