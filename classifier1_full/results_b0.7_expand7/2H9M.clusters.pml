load /home/assaf/workspace/peptalk/classifier1_full/results_b0.7_expand7/2H9M.results.pdb;bg white;hide everything;select receptor, chain A;deselect;select peptide, chain B;deselect;color yellow, peptide;show sticks, peptide;show spheres, receptor;
color white, receptor
select cluster0_ca, receptor and name CB and (resi 23,24,25,25,26,65,66,67,67,68,69,107,108,109,109,110,111,149,150,151,151,152,152,192,193,194,194,195,195,236,237,238,238,239,280,281,281); deselect
select cluster0_red, br. cluster0_ca; deselect
delete cluster0_ca
color red, cluster0_red
select cluster1_ca, receptor and name CB and (resi 17,18,19,19,20,33,34,35,60,61,62,75,102,103,103,104,118,119,143,144,145,188,189,230,231,231,232,233,233,234,235,273,274,275,275,276,277,289,290,291); deselect
select cluster1_orange, br. cluster1_ca; deselect
delete cluster1_ca
color orange, cluster1_orange
