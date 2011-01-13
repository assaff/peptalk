load /home/assaf/workspace/peptalk/classifiers/classifier1_full/results_b0.3/1CKA.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 1,2,3,5,7,8,9,10,13,14,16,17,19,21,24,25,35,36,42,52,53,56,57); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
