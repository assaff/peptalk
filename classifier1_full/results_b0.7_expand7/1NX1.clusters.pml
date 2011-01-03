load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1NX1.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 54,55,136,137,139,140,140,141,142,143,144,144,145,145,146,146,147,148,148,151,151,152,159,159,161,161,165,166,166,167,168,168,169,169,170,170,171,171,172,172,173); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 6,9,9,10,13,13,14,20,24,25,28,28,29,32,32,33,69,70,72,73,73,76,77,77,79,80,80,83); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 22,44,46,48,48,49,50,50,51,52,53,54,132,136); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
