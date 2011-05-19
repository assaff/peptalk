load /vol/ek/share/pdb/df/pdb2df6.ent.gz, 2df6_bound
select bound_2df6_b, polymer and 2df6_bound and chain b
load /vol/ek/share/pdb/g6/pdb2g6f.ent.gz, 2g6f_unbound
select unbound_2g6f_x, polymer and 2g6f_unbound and chain x
align polymer and name ca and bound_2df6_b, polymer and name ca and unbound_2g6f_x, quiet=0, object="aln_bound_unbound", reset=1
select peptide_2df6_d, polymer and 2df6_bound and chain d
deselect
color lime, 2df6_bound
color forest, bound_2df6_b
color cyan, 2g6f_unbound
color blue, unbound_2g6f_x
color red, peptide_2df6_d
show_as cartoon, all
orient
show sticks, sc. and peptide_2df6_d
symexp unbound_sym, 2g6f_unbound, (2g6f_unbound), 5.0
symexp bound_sym, 2df6_bound, (2df6_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_2df6, 2df6_bound and not polymer and not resn HOH
select ligands_2g6f, 2g6f_unbound and not polymer and not resn HOH
show_as spheres, ligands_2df6 or ligands_2g6f
