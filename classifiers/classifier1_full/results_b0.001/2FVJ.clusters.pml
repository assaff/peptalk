load /home/assaf/workspace/peptalk/classifiers/classifier1_full/results_b0.001/2FVJ.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 66,69); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 78,79,82,85,87,92,93,95,96,99,247,248,251,252,253,255,256); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 3,4); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 21,26,123,124); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
select cluster4_ca, receptor and name CB and (resi 214,215,217,221,222,224,225,228,232,258); deselect
select cluster4_green, br. cluster4_ca; deselect
delete cluster4_ca
color green, cluster4_green
select cluster5_ca, receptor and name CB and (resi 53,61); deselect
select cluster5_cyan, br. cluster5_ca; deselect
delete cluster5_ca
color cyan, cluster5_cyan
select cluster6_ca, receptor and name CB and (resi 177,179); deselect
select cluster6_blue, br. cluster6_ca; deselect
delete cluster6_ca
color blue, cluster6_blue
select cluster7_ca, receptor and name CB and (resi 238,240); deselect
select cluster7_violet, br. cluster7_ca; deselect
delete cluster7_ca
color violet, cluster7_violet
select cluster8_ca, receptor and name CB and (resi 205,207); deselect
select cluster8_magenta, br. cluster8_ca; deselect
delete cluster8_ca
color magenta, cluster8_magenta
select cluster9_ca, receptor and name CB and (resi 183,188); deselect
select cluster9_pink, br. cluster9_ca; deselect
delete cluster9_ca
color pink, cluster9_pink
select cluster10_ca, receptor and name CB and (resi 42,44,45,46,118,136); deselect
select cluster10_black, br. cluster10_ca; deselect
delete cluster10_ca
color black, cluster10_black
