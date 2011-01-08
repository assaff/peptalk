load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/2B9H.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 98,99,100,101,101,102,102,103,104,105,106,106,107,139,140,141,141,142); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 18,19,19,21,21,26,27,28,29,40); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 134,136,160,177,184,184,185,185,187,188,278); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 51,104,139,164,164,165,165,166,167,167,168,169,169,170,170,171,171,172,173,178,195,199,202,203,203,204,204,205,207,208,208,211,211,212,212,214,215,216); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
select cluster4_ca, receptor and name CB and (resi 68,69,69,70,96,97,97,98,99,100,103,109,110,110,111,112,112,113,113,114,115,116,116,117,117,118,119,120,121,127,143,144,145,145,146,147,148,148,149,149,150,150,151,152,200,293,296,296,297,298,298,299,301,302,303,303); deselect
select cluster4_green, br. cluster4_ca; deselect
delete cluster4_ca
color green, cluster4_green
select cluster5_ca, receptor and name CB and (resi 255,267,268,268,269,270,271,271,274,292); deselect
select cluster5_cyan, br. cluster5_ca; deselect
delete cluster5_ca
color cyan, cluster5_cyan
