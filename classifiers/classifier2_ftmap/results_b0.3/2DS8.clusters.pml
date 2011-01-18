load /home/assaf/workspace/peptalk/classifiers/classifier2_ftmap/results_b0.3/2DS8.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 2,3,4,6,7,8,12,13,15,16,17,18,19,20,24,31,33,34,35,37,38); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
