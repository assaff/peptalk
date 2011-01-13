load /home/assaf/workspace/peptalk/classifiers/classifier1_full/results_b0.001/2HPL.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 1,2,4,7,10,18,19,22,26,27,30,34,35,39,40,42,44,47,51,55,56,62,65,71,74,75,83,85,86,89,92,97,98,100); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
