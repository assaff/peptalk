load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/2P0W.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 33,160,163,164,164,165,165,166,167,177,200,201,202,203,203,204,213,214,215,215,216,217,217,218,218,219,220,252,253,254,254,255,255,256,256,257,257,258,258,259,259,260,261,263); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 15,29,221,222,223,223,224,224,225,226,226,228,228,230); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 265,269,292,296,302,303,303,304,304,305,306,308,308,309,310,311,311,312,312,313,315,316,316,317); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 6,7,8,33,34,35,35,36,38,40,42,42,43); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
