load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/2O02.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 14,38,39,41,42,42,43,44,45,45,46,46,47,48,49,50,115); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 52,56,84,88,107,110,111,113,114,114,115,118,119,121,122,122,123,124,125,125,126,143,146,150,154,158,159,159,160,160,161,162,164,165,166,166,167,169,170,170,171,172,173,173,174,174,175,176,177,177,178,179,182,186,204,204,205,206,207,207,208,209,210,210,211,211,212,213,214,214,215,216,217,217,218,218,219,220,221,221,222,224); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
