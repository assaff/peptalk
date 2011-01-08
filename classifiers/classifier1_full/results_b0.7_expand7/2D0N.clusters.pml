load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/2D0N.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 5,6,7,8,8,9,9,10,11,11,12,12,13,13,15,15,16,16,17,19,20,32,35,35,36,37,46,46,47,48,49,50,50,51,51,52); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 1,2,3,24,27,52,53,53,54,54,55,55,56,56); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
