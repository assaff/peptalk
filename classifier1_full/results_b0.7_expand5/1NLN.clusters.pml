load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand5/1NLN.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 117,117,200,200,201); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 75,75,76,76,78,86,86,109,109,110,110,111,111,113,113,131,140,140,141,141,146,146,149,149,169); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 25,26,26,27,27,29,29,47,47,93,93,95,95,101,103,103,106,106); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
