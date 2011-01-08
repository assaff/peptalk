load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/2O4J.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 50,53,54,56,57,57,60,61,61,66,69,72,73,74,74,75,75,76,77,78,78,79,79,80,81,82,230,231,231,232,232,233,234,235,235,236,236,237); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 14,21,89,90,91,92,92,93,141,142,142,143,145,146); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 195,196,196,197,198,199,199,202,203,203,204,205,206,206,207,209); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 155,156,157,157,158,167,168,168,171,172); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
