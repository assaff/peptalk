load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1NLN.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 116,117,117,118,119,197,200,200,201); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 68,69,70,71,74,75,75,76,76,78,79,85,86,86,87,88,109,109,110,110,111,111,112,113,113,114,124,128,131,139,140,140,141,141,143,145,146,146,149,149,150,152,154,166,169,173); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 24,25,26,26,27,27,28,29,29,43,44,45,47,47,48,64,66,68,85,90,91,92,93,93,94,95,95,97,98,99,101,102,103,103,105,106,106); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
