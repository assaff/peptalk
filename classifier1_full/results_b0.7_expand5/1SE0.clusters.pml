load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand5/1SE0.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 41,42,44,45,45,47,47,48,48,49,49,51,51,52,52,53,53,56,56,57,57,60,61,61,65,65,66,69,70,70,74,74,75); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 80,80,81,81,82,83,83,84,84,86,86,87); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 2,2,3,4,43,43); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
