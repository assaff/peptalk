load /home/assaf/workspace/peptalk/classifiers/classifier2_ftmap/results_b0.3/1GYB.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 4,6,8,9,12,13,16,19,34,61,63,64,65,66,68,70,79,81,88,95,108,109,116,118,119); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
