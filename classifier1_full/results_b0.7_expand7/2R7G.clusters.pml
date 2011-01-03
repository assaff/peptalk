load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/2R7G.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 213,216,282,283,283,284,284,285,286,286,290); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 77,78,80,81,81,82,85,85,88,89,94,97,97,98,100,100,102,102,103,103,104,105,106,107,142,144,145,145,146,147,148,148,149,149,150,151,152,153,198); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 197,197,198,200,200,201,204); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 162,163,165,166,166,167,168,169,170,170,171,171,172,173,174,175,176,209); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
select cluster4_ca, receptor and name CB and (resi 288,288,289,292,292,293,303); deselect
select cluster4_green, br. cluster4_ca; deselect
delete cluster4_ca
color green, cluster4_green
select cluster5_ca, receptor and name CB and (resi 138,139,139,140,141,142,176,178,179,179,181,181,182,249); deselect
select cluster5_cyan, br. cluster5_ca; deselect
delete cluster5_ca
color cyan, cluster5_cyan
