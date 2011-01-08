load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1TP5.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 16,18,23,23,25,25,26,26,27,27,28,28,36,37,38,39,39,40,40,41,43,46,47,48,48,49,53,55,62,72,73,75,76,76,78,79,79,80,80,82,86); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 12,14,38,50,52,52,53,54,54,55,57); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
