load /home/assaf/workspace/peptalk/classifiers/classifier1_full/results_b0.001/1TP5.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 23,25,26,27,28,31,34,39,40,54,55,71,72,73,76,79,80,101,102,114,115); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 43,48,49); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 66,68); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 15,52); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
