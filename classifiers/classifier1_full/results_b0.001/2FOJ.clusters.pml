load /home/assaf/workspace/peptalk/classifiers/classifier1_full/results_b0.001/2FOJ.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 4,5,6,8,10,12,14,15,17,18,20,21,26,27,29,40,42,50,67,82,84,85,86,87,89,92,93,94,96,97,99,100,101,104,107,118,120,130,131,133,135,137); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
