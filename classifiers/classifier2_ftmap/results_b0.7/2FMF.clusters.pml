load /home/assaf/workspace/peptalk/classifiers/classifier2_ftmap/results_b0.7/2FMF.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 1,76,78,79,94,98,103,105,116,118,120,121,125,126,128); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
