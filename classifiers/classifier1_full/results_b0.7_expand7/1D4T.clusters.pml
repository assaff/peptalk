load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1D4T.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 8,10,10,11,12,13,13,17,17,20,30,31,32,32,33,34,35,35,36,36,37,37,40,41,42,43,44,45,46,47,50,50,51,51,52,52,53,53,54,54,55,55,56,65,66,66,67,67,68,68,69,69,72,72,73,73,74,74,75,83,86,87,91,92,92,94,94,95,96,97); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 1,2,3,3,4,64,77,79,79,80,81,82); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 5,6,7,8,29,101,101,102,104,104); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
