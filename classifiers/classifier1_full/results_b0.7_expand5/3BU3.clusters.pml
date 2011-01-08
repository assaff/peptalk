load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand5/3BU3.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 16,16,18,18,24,24); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 97,97,99,100,150,150); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 146,146,167,175,175,176,176,181,181,182,182,183,183,184,184,186,187,187,188,191,191,192,192,194,194,196,201,225,225,226,226,228,228,230,230); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 1,1,3,3,4,4,66,66,79); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
select cluster4_ca, receptor and name CB and (resi 169,169,170,170); deselect
select cluster4_green, br. cluster4_ca; deselect
delete cluster4_ca
color green, cluster4_green
select cluster5_ca, receptor and name CB and (resi 103,103,106,106,109); deselect
select cluster5_cyan, br. cluster5_ca; deselect
delete cluster5_ca
color cyan, cluster5_cyan
select cluster6_ca, receptor and name CB and (resi 47,47,50,51,51,54); deselect
select cluster6_blue, br. cluster6_ca; deselect
delete cluster6_ca
color blue, cluster6_blue
select cluster7_ca, receptor and name CB and (resi 7,7,80,85,85); deselect
select cluster7_violet, br. cluster7_ca; deselect
delete cluster7_ca
color violet, cluster7_violet
