load /home/assaf/workspace/peptalk/classifiers/classifier1_full/results_b0.001/2P1T.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 9,13,15,20,23,27,30,33,34,37,50,51,54,55,56,69,132,134,199,203,206,209,210,211); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 97,101,104,169,173,176,179,180,183,187,190,193,194,195); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
