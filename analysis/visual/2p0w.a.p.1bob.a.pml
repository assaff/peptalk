load /vol/ek/share/pdb/p0/pdb2p0w.ent.gz, 2p0w_bound
select bound_2p0w_a, polymer and 2p0w_bound and chain a
load /vol/ek/share/pdb/bo/pdb1bob.ent.gz, 1bob_unbound
select unbound_1bob_a, polymer and 1bob_unbound and chain a
align polymer and name ca and bound_2p0w_a, polymer and name ca and unbound_1bob_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_2p0w_p, polymer and 2p0w_bound and chain p
deselect
color lime, 2p0w_bound
color forest, bound_2p0w_a
color cyan, 1bob_unbound
color blue, unbound_1bob_a
color red, peptide_2p0w_p
show_as cartoon, all
orient
show sticks, sc. and peptide_2p0w_p
symexp unbound_sym, 1bob_unbound, (1bob_unbound), 5.0
symexp bound_sym, 2p0w_bound, (2p0w_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_2p0w, 2p0w_bound and not polymer and not resn HOH
select ligands_1bob, 1bob_unbound and not polymer and not resn HOH
show_as spheres, ligands_2p0w or ligands_1bob
