load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1OAI.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 11,14,15,20,21,22,22,23,23,24,24,25,26,27,27,28,28,29,30,30,31,31,32,32,34,35,38,39,42,42,43,46,46,51,51,52,53,53,55,56,57,57,58,58,59,59); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 10,13,13,14,16,17,17,18); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 1,1,2,2,3); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
