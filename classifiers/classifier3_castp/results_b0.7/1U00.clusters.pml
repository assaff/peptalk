load /home/assaf/workspace/peptalk/classifiers/classifier3_castp/results_b0.7/1U00.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 208,211,212,213,215,216,219); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 2,3,5,11,13,18,19,23,24,26,28,30,32,33,35,36,38,40,42,43,45,61,62,63,65,76,82,84,86,89,90,111,112,113,114,150,154); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
