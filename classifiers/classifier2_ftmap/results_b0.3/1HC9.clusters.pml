load /home/assaf/workspace/peptalk/classifiers/classifier2_ftmap/results_b0.3/1HC9.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 6,7,8,9,11,14,15,17,27,30,32,36,38,39,40,41,68,69,70,71,72,73); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
