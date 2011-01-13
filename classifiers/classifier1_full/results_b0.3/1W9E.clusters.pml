load /home/assaf/workspace/peptalk/classifiers/classifier1_full/results_b0.3/1W9E.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 15,16,18,30,31,66,70); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 1,3,4,44,83,85,86,87,88,99,100,102,104,106,136,138,140,142,146,149,150,163,164); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 39,40); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 133,157); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
select cluster4_ca, receptor and name CB and (resi 56,58); deselect
select cluster4_green, br. cluster4_ca; deselect
delete cluster4_ca
color green, cluster4_green
