load /home/assaf/workspace/peptalk/classifiers/classifier1_full/results_b0.001/1JD5.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 2,3,4,8,11,13,33,36,42,47,49,53,57,58,59,60,61,63,64,65,69,73,74,75,76,78,82,83,84,102,103,105); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
