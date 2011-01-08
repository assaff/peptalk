load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand5/1LVM.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 9,9,10,10,12,12,13,13,15,32,46,46,81,110,111,123,123,125,125,126,126,139,144,145,145,146,146,147,147,148,148,150,151,151,153,167,167,168,168,169,169,170,170,171,171,174,174,178,178,179,180,207,211,211,214,214,215,215,216,216,218,218,219); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 57,61,61,64,64,92,92); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 25,52,52,68,68); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
