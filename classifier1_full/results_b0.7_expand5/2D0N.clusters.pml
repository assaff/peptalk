load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand5/2D0N.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 7,8,8,9,9,11,11,12,12,13,13,15,15,16,16,35,35,46,46,48,50,50,51,51); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 1,2,3,52,53,53,54,54,55,55,56,56); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
