load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1UJ0.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 7,8,9,10,10,11,11,12,13,14,15,15,17,17,18,18,19,20,21,34,36,36,37,37,38,39,48,48,49,50,51,52,53,53,54); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 2,3,3,4,5,29,55,56,56); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
