load /home/assaf/workspace/peptalk/classifiers/classifier1_full/results_b0.3/2V3S.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 8,10,11,12,14,17,18,19,20,21,22,28,29,33,36,37,39,40,42,69,92,96); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 44,49,50,53,71,73,74,81,82); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
