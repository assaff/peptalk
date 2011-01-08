load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/2CCH.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 55,56,59,87,88,89,90,91,91,92,92,93,93,94,97,124,127,129,129,130,131,132,132,133); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 25,30,31,32,32,34,35,35,36,37,38,38,39,39,40,41,42,42,43,44,45,45,46,46,49,49,50,73,75,75,77,78,78,79,79,80,81,83,86,98,99,102,102,103,104,105,106,106,107,107,108,108,109,109,110,110,111,233); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 1,1,2,2,3,3,6,6,7,7,8,10,10,11,14); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
