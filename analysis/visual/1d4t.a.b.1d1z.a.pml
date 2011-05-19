load /vol/ek/share/pdb/d4/pdb1d4t.ent.gz, 1d4t_bound
select bound_1d4t_a, polymer and 1d4t_bound and chain a
load /vol/ek/share/pdb/d1/pdb1d1z.ent.gz, 1d1z_unbound
select unbound_1d1z_a, polymer and 1d1z_unbound and chain a
align polymer and name ca and bound_1d4t_a, polymer and name ca and unbound_1d1z_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1d4t_b, polymer and 1d4t_bound and chain b
deselect
color lime, 1d4t_bound
color forest, bound_1d4t_a
color cyan, 1d1z_unbound
color blue, unbound_1d1z_a
color red, peptide_1d4t_b
show_as cartoon, all
orient
show sticks, sc. and peptide_1d4t_b
symexp unbound_sym, 1d1z_unbound, (1d1z_unbound), 5.0
symexp bound_sym, 1d4t_bound, (1d4t_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1d4t, 1d4t_bound and not polymer and not resn HOH
select ligands_1d1z, 1d1z_unbound and not polymer and not resn HOH
show_as spheres, ligands_1d4t or ligands_1d1z
