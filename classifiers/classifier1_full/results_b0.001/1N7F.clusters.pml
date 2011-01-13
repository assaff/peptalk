load /home/assaf/workspace/peptalk/classifiers/classifier1_full/results_b0.001/1N7F.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 1,3,14,15,17,18,19,20,28,30,32,33,39,41,42,43,51,65,66,69,70,72,73,74,84,85,86); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 56,57,59); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
