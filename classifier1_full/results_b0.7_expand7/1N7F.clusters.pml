load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1N7F.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 8,10,14,14,15,15,17,17,18,18,19,19,20,20,29,30,31,32,33,34,39,39,40,42,43,46,52,55,64,65,65,66,68,69,69,70,71,72,72,73,73,74,75,79); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 28,28,29,30,50,51,51,52,53,83,84,85,85,86,86); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
