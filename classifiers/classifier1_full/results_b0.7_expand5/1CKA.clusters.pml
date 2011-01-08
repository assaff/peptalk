load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand5/1CKA.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 7,8,8,9,9,10,10,13,13,14,14,17,17,19,19,35,35,36,36,50,51,52,52,53,53); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 1,1,2,2,3,3,6,20,24,24,25,25,28,56,56,57,57); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
