load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/1SFI.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 1,2,25,38,39,40,40,41,81,84,118,123,124,124,126,126,132,136,171,172,172,173,173,174,174,176,177,177,191,192,193,193,197,198,205); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 80,80,81,82,156,157,157,159,160); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
select cluster2_ca, receptor and name CB and (resi 2,117,138,139,139,140,165,170,170,171,198); deselect
select cluster2_yellow, br. cluster2_ca; deselect
delete cluster2_ca
color yellow, cluster2_yellow
