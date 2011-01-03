load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/2V3S.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 3,5,6,7,8,8,9,10,10,11,11,12,12,14,14,15,16,17,17,18,18,19,19,20,20,21,21,22,22,23,24,27,28,28,29,30,33,33,34,35,36,36,37,37,38,39,40,40,42,42,43,51,55,69,87,88,90,91,92,92,93,94); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 43,44,44,47,48,49,49,50,50,51,52,53,54,70,71,71,72,73,73,74,74,81,82,82,83,88,90); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
