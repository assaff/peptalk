load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1DKX.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 13,13,14,14,15,15,16,16,19,20,21,23,36,38,38,39,39,40,40,41,41,42,43,43,44,45,45,46,47,47,48,48,49,49,50,50,51,52,53,60,68,69,70,71,72,74,79,82,83,84,86,98,100,149,156,157,160,160,161,164); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 66,93,95,113,114,114,115,115,116,116,117,117); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 4,5,6,6,7,8,8,9,27,28,29,124); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 1,1,2,2,3,3,4,5); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
