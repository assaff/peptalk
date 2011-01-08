load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand5/2FMF.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 1,1,76,76,79,79,81,103,103,122,123,125,125,126,126,128,128); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 94,94,98,98,105,105,116,116,118,118); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 12,12,19,19,57,58,58,59,60,60,87,87,107,107,108,109,109,111,111,114); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
