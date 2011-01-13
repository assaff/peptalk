load /home/assaf/workspace/peptalk/classifiers/classifier1_full/results_b0.001/2DS8.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 3,6,7,8,10,12,15,17,18,19,20,22,24,28,29,31,33,34,35,37,38,40); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
