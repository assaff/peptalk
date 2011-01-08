load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/2J6F.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 5,6,7,7,8,8,9,9,11,12,15,15,16,16,17,18,18,19,30,30,31,33,33,34,36,36,37,47,48,49,49,50,50,51,51,52,52,53); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 1,1,3,28,54,55,55,56,57); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 3,4,4,5,6,19,23,23,24,25,41,53,54,56); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
