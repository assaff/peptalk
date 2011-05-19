load /vol/ek/share/pdb/j6/pdb2j6f.ent.gz, 2j6f_bound
select bound_2j6f_a, polymer and 2j6f_bound and chain a
load /vol/ek/share/pdb/da/pdb2da9.ent.gz, 2da9_unbound
select unbound_2da9_a, polymer and 2da9_unbound and chain a
align polymer and name ca and bound_2j6f_a, polymer and name ca and unbound_2da9_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_2j6f_c, polymer and 2j6f_bound and chain c
deselect
color lime, 2j6f_bound
color forest, bound_2j6f_a
color cyan, 2da9_unbound
color blue, unbound_2da9_a
color red, peptide_2j6f_c
show_as cartoon, all
orient
show sticks, sc. and peptide_2j6f_c
symexp unbound_sym, 2da9_unbound, (2da9_unbound), 5.0
symexp bound_sym, 2j6f_bound, (2j6f_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_2j6f, 2j6f_bound and not polymer and not resn HOH
select ligands_2da9, 2da9_unbound and not polymer and not resn HOH
show_as spheres, ligands_2j6f or ligands_2da9
