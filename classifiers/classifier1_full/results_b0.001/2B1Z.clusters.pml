load /home/assaf/workspace/peptalk/classifiers/classifier1_full/results_b0.001/2B1Z.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 149,165,169,172,173); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 19,20,21,22,24,51,52,54,58,59,68,71,72,73,75,76,96,102,106,107,117,120,124,128,130,133,194,195,197,198,201,202,204,205,208,209,212,215,218,219,220,223,225,226,227,229,230,231,233,234,235); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 35,113); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 187,188); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
