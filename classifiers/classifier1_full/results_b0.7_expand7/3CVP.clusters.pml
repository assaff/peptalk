load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/3CVP.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 52,58,59,60,61,62,62,63,63,64,66,67,81,82,83,83,84,85,86,86,87,89,90,90,91,92,93,94,94,95,95,96,96,98,108,143,144,145,145,146,148,149,152,155,160,167,177,178,179,179,180,181,182,182,183,183,184,186,186,187,188,189,189,190,190,194,197,201,204,211,212,213,213,214,216,217,217,218,219,220,220,221,223,224,224,225,242); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 31,212,215,236,237,238,239,240,240,241,241,242,243,243,244,244,245,245,246,246,247,248,250,272); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 11,16,17,19,20,20,24,25,25,26,33,36,57); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
select cluster3_ca, receptor and name CB and (resi 48,51,73,74,75,77,77,79,79); deselect
select cluster3_forest, br. cluster3_ca; deselect
delete cluster3_ca
color forest, cluster3_forest
