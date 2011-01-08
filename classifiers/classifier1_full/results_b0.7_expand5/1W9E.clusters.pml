load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand5/1W9E.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 44,44,45,92,99,99,100,100,102,102,104,104,118,136,136,137,138,138,140,140,142,142,146,146,149,149,150,150); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 8,15,15,16,16,18,18,30,30,31,31,37,38,66,66,70,70); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 84,85,85,86,86,87,87,88,88,161); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
