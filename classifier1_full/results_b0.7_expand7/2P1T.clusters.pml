load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/2P1T.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 26,29,30,32,33,36,42,45,49,50,50,51,51,52,53,54,54,55,55,56,56,58,130,131,132,132,133,134,134,203,203,204,206,206,207,208,209,209,210,210,211,211); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 60,168,169,169,172,173,173,174,175,176,176,177,178,179,179,180,183); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 11,14,15,15,65,66,68,69,69,70,78); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
