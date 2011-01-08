load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand5/1TP5.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 23,23,25,25,26,26,27,27,28,28,39,39,40,40,41,47,48,48,76,76,79,79,80,80); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 14,50,52,52,54,54); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
