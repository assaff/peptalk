load /home/assaf/workspace/peptalk/classifiers/classifier3_castp/results_b0.3/2O02.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 114,122,125,159,160,166,170,173,174,177,179,202,203,204,205,206,207,209,210,211,213,214,216,217,218,220,221,223,224); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 14,16,17,18,37,39,42,45,46,50,54,58,61,65,68,76); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 187,191,192,194,196,197,198); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
