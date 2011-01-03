load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1ER8.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 38,73,74,75,75,76,76,77,77,79,79,81,82,82,83,111,113,133); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 34,36,37,127,128,130,131,131,132,192,192,193,194,215,216,217,217,218,220,220,221,222,224,295,298,298,300,302,303,305); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 23,23,24,24,62,63,63,64,64,65,90,91); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 99,102,129,140,141,142,143,144,144,145,145,146,147); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
select cluster4_ca, receptor and name CB and (resi 8,11,11,12,13,13,14,14,15,16,31,120,221,278); deselect
select cluster4_green, br. cluster4_ca; deselect
delete cluster4_ca
color green, cluster4_green
select cluster5_ca, receptor and name CB and (resi 2,2,3,156,166,168,171,172,173,173,175,176); deselect
select cluster5_cyan, br. cluster5_ca; deselect
delete cluster5_ca
color cyan, cluster5_cyan
