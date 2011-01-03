load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/2B1Z.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 18,19,19,20,20,21,21,22,23,47,49,50,51,51,52,52,53,54,54,56,57,58,58,59,63,66,68,68,70,71,71,72,72,73,74,75,75,76,76,77,78,140,211,224,225,226,227,227,228,229,229,230,230,231,231,232,233,234,234,235,235); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 80,118,150,200,201,202,203,204,204,205,205,206,207,208,209,209,212,213); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 165,168,169,169,170,171,172,172,173,175,176); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 145,146,148,149,149,150,152,168,193,194,196,197,197,198,200); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
