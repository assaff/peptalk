load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/2QOS.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 23,24,24,25,26,27,41,43,44,45,46,94,96,109,110,111,111,112,113,118,119,120,120,121,122,151,153,153); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 42,43,44,46,57,58,59,59,60,61,61,62,63,63,68,69,70,70,72,86,87,88,88,91,91,159,167,168,168,170,170,171); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 29,30,31,31,33,33,34,37,37,40,118); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 99,100,100,101,108,119,136,139,139,140,143); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
