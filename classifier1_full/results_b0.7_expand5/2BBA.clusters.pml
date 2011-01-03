load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand5/2BBA.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 18,18,20,20); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 25,25,30,30,32,32,34,34,48,48,50,50,58,58,79,84,84,85,88,88,97,97,98,98,99,99,101,126,126,127,128,128,129,129,131,131,133,133,134,134,147,150,150,151,151,172,173,173,174,174,175); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 5,5,6,6,182); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
