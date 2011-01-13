load /home/assaf/workspace/peptalk/classifiers/classifier1_full/results_b0.001/2PUY.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 5,6,16,17,18,19,21,26,40,41,43,44); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 33,34,35,47,50); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 10,11); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 57,58,60); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
