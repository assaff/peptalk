load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/2P1K.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 7,8,8,9,10,10,11,37,41,52,53,53,54,55,55,56,59,60,60,62,62,63,64,64,65,66,66,67,67,70,71,71,72,73,73,74,80,81,82,82,83,84,85); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 33,33,34,34,35,36,37,38,38,39,41,42,42,43,45,56); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 1,1,2,23,26,27,27,36,76); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
