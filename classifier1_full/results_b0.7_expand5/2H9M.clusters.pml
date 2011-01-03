load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand5/2H9M.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 25,25,67,67,109,109,111,151,151,152,152,194,194,195,195,238,238,281,281); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 19,19,20,33,61,103,103,104,145,188,231,231,233,233,275,275,276); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
