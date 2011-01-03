load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1LVM.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 9,9,10,10,11,12,12,13,13,14,15,16,32,33,44,45,46,46,47,49,80,81,97,110,111,112,114,122,123,123,125,125,126,126,127,134,138,139,140,144,145,145,146,146,147,147,148,148,150,151,151,153,155,158,166,167,167,168,168,169,169,170,170,171,171,172,174,174,177,178,178,179,180,204,207,208,209,211,211,214,214,215,215,216,216,217,218,218,219); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 57,59,61,61,64,64,91,92,92,93); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 25,50,51,52,52,66,68,68,69); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
