load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1DDV.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 1,1,2,30,31,32,32,33,34,41,42,43,43,44,45,50,50,51,52,53,53,54,55,74,76,76,77,77,78,79); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 57,58,59,59,60,61,61,62,63,63,64,64,65,66,68,69,69,71,72,73,73,74,80,83,91,95); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 7,9,11,18,19,19,20,21,21,22,23); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
