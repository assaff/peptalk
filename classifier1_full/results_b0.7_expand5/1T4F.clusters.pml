load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand5/1T4F.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 19,19,27,29,29,32,32,35,35,37,37,39,39,40,40,42,42,44); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 45,46,46,50,50,51,51,52,70,71,71,72,72,74,74,77,77); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
