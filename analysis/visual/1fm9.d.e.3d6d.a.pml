load /vol/ek/share/pdb/fm/pdb1fm9.ent.gz, 1fm9_bound
select bound_1fm9_d, polymer and 1fm9_bound and chain d
load /vol/ek/share/pdb/d6/pdb3d6d.ent.gz, 3d6d_unbound
select unbound_3d6d_a, polymer and 3d6d_unbound and chain a
align polymer and name ca and bound_1fm9_d, polymer and name ca and unbound_3d6d_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1fm9_e, polymer and 1fm9_bound and chain e
deselect
color lime, 1fm9_bound
color forest, bound_1fm9_d
color cyan, 3d6d_unbound
color blue, unbound_3d6d_a
color red, peptide_1fm9_e
show_as cartoon, all
orient
show sticks, sc. and peptide_1fm9_e
symexp unbound_sym, 3d6d_unbound, (3d6d_unbound), 5.0
symexp bound_sym, 1fm9_bound, (1fm9_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1fm9, 1fm9_bound and not polymer and not resn HOH
select ligands_3d6d, 3d6d_unbound and not polymer and not resn HOH
show_as spheres, ligands_1fm9 or ligands_3d6d
