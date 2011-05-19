load /vol/ek/share/pdb/d1/pdb3d1e.ent.gz, 3d1e_bound
select bound_3d1e_ab, polymer and 3d1e_bound and chain a+b
load /vol/ek/share/pdb/d1/pdb3d1g.ent.gz, 3d1g_unbound
select unbound_3d1g_ab, polymer and 3d1g_unbound and chain a+b
align polymer and name ca and bound_3d1e_ab, polymer and name ca and unbound_3d1g_ab, quiet=0, object="aln_bound_unbound", reset=1
select peptide_3d1e_p, polymer and 3d1e_bound and chain p
deselect
color lime, 3d1e_bound
color forest, bound_3d1e_ab
color cyan, 3d1g_unbound
color blue, unbound_3d1g_ab
color red, peptide_3d1e_p
show_as cartoon, all
orient
show sticks, sc. and peptide_3d1e_p
symexp unbound_sym, 3d1g_unbound, (3d1g_unbound), 5.0
symexp bound_sym, 3d1e_bound, (3d1e_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_3d1e, 3d1e_bound and not polymer and not resn HOH
select ligands_3d1g, 3d1g_unbound and not polymer and not resn HOH
show_as spheres, ligands_3d1e or ligands_3d1g
