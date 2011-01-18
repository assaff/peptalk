load /home/assaf/workspace/peptalk/classifiers/classifier3_castp/results_b0.3/1U00.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 201,205,208,210,211,212,213,215,216,219,220); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 1,2,3,5,11,13,18,19,22,23,24,26,28,30,32,33,34,35,36,38,40,42,43,44,45,61,62,63,65,76,80,82,84,86,89,90,100,101,102,107,109,111,112,113,114,118,143,147,150,154); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 129,132); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
