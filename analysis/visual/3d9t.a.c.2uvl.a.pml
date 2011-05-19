load /vol/ek/share/pdb/d9/pdb3d9t.ent.gz, 3d9t_bound
select bound_3d9t_a, polymer and 3d9t_bound and chain a
load /vol/ek/share/pdb/uv/pdb2uvl.ent.gz, 2uvl_unbound
select unbound_2uvl_a, polymer and 2uvl_unbound and chain a
align polymer and name ca and bound_3d9t_a, polymer and name ca and unbound_2uvl_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_3d9t_c, polymer and 3d9t_bound and chain c
deselect
color lime, 3d9t_bound
color forest, bound_3d9t_a
color cyan, 2uvl_unbound
color blue, unbound_2uvl_a
color red, peptide_3d9t_c
show_as cartoon, all
orient
show sticks, sc. and peptide_3d9t_c
symexp unbound_sym, 2uvl_unbound, (2uvl_unbound), 5.0
symexp bound_sym, 3d9t_bound, (3d9t_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_3d9t, 3d9t_bound and not polymer and not resn HOH
select ligands_2uvl, 2uvl_unbound and not polymer and not resn HOH
show_as spheres, ligands_3d9t or ligands_2uvl
