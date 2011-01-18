load /home/assaf/workspace/peptalk/classifiers/classifier2_ftmap/results_b0.3/1SSH.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 2,4,5,11,13,15,16,19,27,31,32,33,34,37,38,39,40,44,51,53,55,56); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
