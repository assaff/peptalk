load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/2P54.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 80,83,86,87,87,88,90,91,91,96,99,101,101,102,103,104,104,105,105,106,107,108,108,109,109,110,112,257,258,258,259,260,261,261,262,264,266); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 71,72,74,75,75,76,78,78,79,81,82,131); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 18,19,50,53,54,54,57,74,131,132,132,133,133); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 1,1,2,5,93,94,94); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
select cluster4_ca, receptor and name CB and (resi 114,160,228,229,230,231,231,232,233,233,234,235,236,237); deselect
select cluster4_green, br. cluster4_ca; deselect
delete cluster4_ca
color green, cluster4_green
