load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/2FMF.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 1,1,2,5,76,76,77,78,79,79,80,81,82,83,102,103,103,121,122,123,124,125,125,126,126,128,128); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 27,83,84,91,93,94,94,97,98,98,102,105,105,106,112,114,115,116,116,117,118,118,119,120,121,122); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 11,12,12,13,15,16,19,19,20,23,37,56,57,58,58,59,60,60,63,86,87,87,106,107,107,108,109,109,110,111,111,112,114,115); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
