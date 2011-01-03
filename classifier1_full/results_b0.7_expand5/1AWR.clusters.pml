load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand5/1AWR.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 53,54,54,56,59,59,60,62,80,81,81,87,87,90,90,91,92,92,98,100,101,101,102,102,106,106,112,112,118,121,121,122,122,124,125,125); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 40,40,42,42); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 29,29,85,85,86); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
