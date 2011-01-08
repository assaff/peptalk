load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/3D9T.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 26,28,45,46,47,56,56,57,57,58,58,59,59,60,60,63,63,64,65,67,68,68,69,71,72,72,73); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 5,49,51,52,52,53,53,73,74,75,75,76,78); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 66,70,78,79,81,82,82,83,83,87,88); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
