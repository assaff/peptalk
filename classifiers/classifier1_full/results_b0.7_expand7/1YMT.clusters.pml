load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1YMT.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 47,50,51,53,54,54,55,57,58,71,72,73,74,75,75,76,76,77,78,79,227,228,228,229,230,231,231,232,232,233,234,235,235); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 193,194,196,197,197,198,200,201,201,202,204,205); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 37,112,113,116,116,117,120,121,121,122,124,125,213); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 77,78,151,152,154,155,155,156,157,157,158); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
