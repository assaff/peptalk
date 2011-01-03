load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand5/2CCH.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 56,91,91,92,92,93,93,97,129,129,132,132); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 31,32,32,34,35,35,38,38,39,39,42,42,45,45,46,46,49,49,50,75,75,78,78,79,79,98,102,102,106,106,107,107,108,108,109,109,110,110,111); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 1,1,2,2,3,3,6,6,7,7,10,10); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
