load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/3D1E.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 144,145,172,173,175,175,176,176,177,240,240,241,242,242,243,243,244,245,247,247,248,249,317,319,320,322,323,325,326,326,327,328,329,329,330,344,345,346,347,348,358,359,360,360,361,362,362,363,363,364,364,365,365,366,366); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 150,151,151,152,152,153,153,154,155,156,237); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 122,221,221,222,235,236,237,238,238); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 266,268,269,269,270,271,272,272,273,302,304); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
select cluster4_ca, receptor and name CB and (resi 273,296,298,298,300,300); deselect
select cluster4_green, br. cluster4_ca; deselect
delete cluster4_ca
color green, cluster4_green
select cluster5_ca, receptor and name CB and (resi 78,82,99,101,103,104,104,106,106,107,108); deselect
select cluster5_cyan, br. cluster5_ca; deselect
delete cluster5_ca
color cyan, cluster5_cyan
select cluster6_ca, receptor and name CB and (resi 116,117,118,118,119,120,120,121,122); deselect
select cluster6_blue, br. cluster6_ca; deselect
delete cluster6_ca
color blue, cluster6_blue
select cluster7_ca, receptor and name CB and (resi 24,24,25,27,28,28,29); deselect
select cluster7_violet, br. cluster7_ca; deselect
delete cluster7_ca
color violet, cluster7_violet
select cluster8_ca, receptor and name CB and (resi 71,73,74,74,75,76,77,77,78,80,108); deselect
select cluster8_magenta, br. cluster8_ca; deselect
delete cluster8_ca
color magenta, cluster8_magenta
