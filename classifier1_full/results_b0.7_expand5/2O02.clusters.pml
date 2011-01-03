load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand5/2O02.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 42,42,45,45,46,46); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 114,114,122,122,125,125,146,159,159,160,160,162,164,166,166,170,170,173,173,174,174,177,177,182,204,204,207,207,210,210,211,211,214,214,217,217,218,218,221,221); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
