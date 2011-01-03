load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1W9E.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 29,32,43,44,44,45,47,84,92,94,99,99,100,100,102,102,103,104,104,106,108,109,110,112,116,117,118,123,130,131,132,136,136,137,138,138,140,140,141,142,142,145,146,146,148,149,149,150,150,152,156); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 8,10,15,15,16,16,18,18,20,28,29,30,30,31,31,32,36,37,38,43,45,62,65,66,66,69,70,70,77); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 48,84,85,85,86,86,87,87,88,88,90,130,159,160,161,162,164); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
