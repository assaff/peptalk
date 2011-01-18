load /home/assaf/workspace/peptalk/classifiers/classifier3_castp/results_b0.3/2DS8.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 6,7,8,10,12,15,17,18,19,20,22,24,28,29,33,34,37,40); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
