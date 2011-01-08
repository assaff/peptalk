load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1IHJ.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 9,11,14,16,16,17,17,19,19,20,20,21,22,22,23,38,39,40,40,42,43,43,44,46,47,48,54,55,55,56,56,58,72,73,73,76,77,77,80,81,81,87,93); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 7,9,47,48,50,51,51,53,53,54); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
