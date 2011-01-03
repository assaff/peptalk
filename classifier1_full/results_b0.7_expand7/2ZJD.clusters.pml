load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/2ZJD.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 15,18,19,22,22,23,26,28,29,29,30,31,32,33,34,46,47,47,48,48,49,50,50,51,51,52,52,53,53,54,54,56,57,61,62,65,65,66,69,69,70,94,102,103,105,107,107,108,109); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 1,2,2,4,5,5,6,7,7,9,9,35,36,36,37,38,38,40,41,41,43,45,111,112); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 77,77,78,79,113,114,115,115,116,117,118,118); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 81,85,85,86,87,87,88); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
