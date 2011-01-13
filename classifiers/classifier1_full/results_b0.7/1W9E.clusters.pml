load /home/assaf/workspace/peptalk/classifiers/classifier1_full/results_b0.7/1W9E.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 44,99,100,102,104,136,138,140,142,146,149,150); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 15,16,18,30,31,66,70); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 85,86,87,88); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
