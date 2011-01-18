load /home/assaf/workspace/peptalk/classifiers/classifier2_ftmap/results_b0.3/1CKA.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 1,2,3,8,9,10,11,13,14,15,16,17,19,21,24,25,27,35,36,42,43,45,46,52,53,56,57); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
