load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand5/1NX1.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 140,140,144,144,145,145,146,146,148,148,151,151,159,159,161,161,165,166,166,168,168,169,169,170,170,171,171,172,172); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 9,9,13,13,28,28,32,32,73,73,77,77,80,80); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 22,48,48,50,50,136); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
