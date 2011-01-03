load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1T4F.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 19,19,27,28,29,29,30,31,32,32,33,34,35,35,37,37,38,39,39,40,40,42,42,44,45,53,58); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 45,46,46,48,50,50,51,51,52,53,69,70,71,71,72,72,73,74,74,77,77,78,80,81); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
