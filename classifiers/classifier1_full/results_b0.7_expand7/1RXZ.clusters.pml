load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1RXZ.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 37,39,40,41,41,42,42,43,43,44,44,45,46,46,47,48,120,121,121,122,123,123,125,125,127,151,191,192,193,194,197,214,218,220,220,221,222,237,238,239,239,240,240,241,241,242); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 9,11,12,12,13,15,16,76,78,79,79,81); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 16,20,149,150,150,151,194,195,196,196,197,200,200,201,202,203,203,204); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 19,22,23,23,24,24,25,70,71,111,116,117,117); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
