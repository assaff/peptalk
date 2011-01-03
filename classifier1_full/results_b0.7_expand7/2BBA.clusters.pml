load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/2BBA.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 17,18,18,19,20,20,21,33,45); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 23,25,25,30,30,31,32,32,33,34,34,35,46,47,48,48,49,50,50,51,52,58,58,59,60,78,79,80,81,82,83,84,84,85,86,87,88,88,89,96,97,97,98,98,99,99,100,101,102,103,124,126,126,127,128,128,129,129,130,131,131,132,133,133,134,134,135,136,147,148,149,150,150,151,151,153,169,172,173,173,174,174,175,176); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 5,5,6,6,7,182,184,185); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
