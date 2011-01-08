load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/2C3I.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 88,89,89,90,91,91,92,92,93,94,94,95,96,100,126,127,128,128,129,130,130,131,132,132,133,134,135,147,150,165,165,166,167,168,169,188,192,195,196); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 7,7,8,8,10,10,15,16,17,18,29); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 33,34,34,35,37,37,38,76); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 1,1,2,21,69,69,70,71,71,72,72,73,73,76,77,78,80); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
select cluster4_ca, receptor and name CB and (resi 38,39,40,40,49,159,161,161,162); deselect
select cluster4_green, br. cluster4_ca; deselect
delete cluster4_ca
color green, cluster4_green
