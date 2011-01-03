load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand5/1IHJ.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 9,11,16,16,17,17,19,19,20,20,22,22,40,40,43,43,46,48,55,55,56,56,73,73,77,77,81,81); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 51,51,53,53); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
