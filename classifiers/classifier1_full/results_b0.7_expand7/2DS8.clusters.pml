load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/2DS8.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 3,3,5,6,6,7,7,8,8,10,11,12,12,15,15,17,17,18,18,19,19,20,20,22,24,24,25,26,27,28,29,30); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 29,30,31,33,33,34,34,35,37,37,38,38,40); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
