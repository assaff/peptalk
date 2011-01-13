load /home/assaf/workspace/peptalk/classifiers/classifier1_full/results_b0.3/1SE0.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 45,47,48,49,51,52,53,56,57,60,61,65,66,67,68,74,93,94,95,97); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 2,43,78,80,81,82,83,84,86,88,89); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
