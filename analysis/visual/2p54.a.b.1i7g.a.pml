load /vol/ek/share/pdb/p5/pdb2p54.ent.gz, 2p54_bound
select bound_2p54_a, polymer and 2p54_bound and chain a
load /vol/ek/share/pdb/i7/pdb1i7g.ent.gz, 1i7g_unbound
select unbound_1i7g_a, polymer and 1i7g_unbound and chain a
align polymer and name ca and bound_2p54_a, polymer and name ca and unbound_1i7g_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_2p54_b, polymer and 2p54_bound and chain b
deselect
color lime, 2p54_bound
color forest, bound_2p54_a
color cyan, 1i7g_unbound
color blue, unbound_1i7g_a
color red, peptide_2p54_b
show_as cartoon, all
orient
show sticks, sc. and peptide_2p54_b
symexp unbound_sym, 1i7g_unbound, (1i7g_unbound), 5.0
symexp bound_sym, 2p54_bound, (2p54_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_2p54, 2p54_bound and not polymer and not resn HOH
select ligands_1i7g, 1i7g_unbound and not polymer and not resn HOH
show_as spheres, ligands_2p54 or ligands_1i7g
