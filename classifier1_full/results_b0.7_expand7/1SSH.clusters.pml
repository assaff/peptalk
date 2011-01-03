load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1SSH.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 2,2,3,4,4,5,8,9,9,10,12,15,15,16,16,19,19,20,21,29,30,32,33,33,34,34,37,38,38,39,39,40,40,41,42,51,51,52,53,53,54,55,55,56,56,57,59); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
