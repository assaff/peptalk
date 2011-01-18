load /home/assaf/workspace/peptalk/classifiers/classifier2_ftmap/results_b0.3/2V3S.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 8,10,11,12,13,14,17,18,19,20,21,22,28,33,36,37,40,42,44,46,49,50,71,73,74,80,82,92); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
