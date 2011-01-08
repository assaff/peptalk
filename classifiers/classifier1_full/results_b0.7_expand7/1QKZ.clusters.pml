load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1QKZ.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 11,11,12,91,114,115,116,116,117,118,153); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 35,37,38,39,45,45,46,46,47,47,48,61); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 122,153,154,154,174,181,205,206,207,207); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 40,41,41,91,174,175,175,176,182); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
select cluster4_ca, receptor and name CB and (resi 4,35,95,97,98,99,106,106,109,109); deselect
select cluster4_green, br. cluster4_ca; deselect
delete cluster4_ca
color green, cluster4_green
select cluster5_ca, receptor and name CB and (resi 32,33,33,34,50,51,52,99,104,104); deselect
select cluster5_cyan, br. cluster5_ca; deselect
delete cluster5_ca
color cyan, cluster5_cyan
select cluster6_ca, receptor and name CB and (resi 192,193,194,195,195,196,196,197); deselect
select cluster6_blue, br. cluster6_ca; deselect
delete cluster6_ca
color blue, cluster6_blue
