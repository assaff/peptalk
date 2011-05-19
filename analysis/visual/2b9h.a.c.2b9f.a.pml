load /vol/ek/share/pdb/b9/pdb2b9h.ent.gz, 2b9h_bound
select bound_2b9h_a, polymer and 2b9h_bound and chain a
load /vol/ek/share/pdb/b9/pdb2b9f.ent.gz, 2b9f_unbound
select unbound_2b9f_a, polymer and 2b9f_unbound and chain a
align polymer and name ca and bound_2b9h_a, polymer and name ca and unbound_2b9f_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_2b9h_c, polymer and 2b9h_bound and chain c
deselect
color lime, 2b9h_bound
color forest, bound_2b9h_a
color cyan, 2b9f_unbound
color blue, unbound_2b9f_a
color red, peptide_2b9h_c
show_as cartoon, all
orient
show sticks, sc. and peptide_2b9h_c
symexp unbound_sym, 2b9f_unbound, (2b9f_unbound), 5.0
symexp bound_sym, 2b9h_bound, (2b9h_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_2b9h, 2b9h_bound and not polymer and not resn HOH
select ligands_2b9f, 2b9f_unbound and not polymer and not resn HOH
show_as spheres, ligands_2b9h or ligands_2b9f
