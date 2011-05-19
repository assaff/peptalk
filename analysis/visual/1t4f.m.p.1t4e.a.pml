load /vol/ek/share/pdb/t4/pdb1t4f.ent.gz, 1t4f_bound
select bound_1t4f_m, polymer and 1t4f_bound and chain m
load /vol/ek/share/pdb/t4/pdb1t4e.ent.gz, 1t4e_unbound
select unbound_1t4e_a, polymer and 1t4e_unbound and chain a
align polymer and name ca and bound_1t4f_m, polymer and name ca and unbound_1t4e_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1t4f_p, polymer and 1t4f_bound and chain p
deselect
color lime, 1t4f_bound
color forest, bound_1t4f_m
color cyan, 1t4e_unbound
color blue, unbound_1t4e_a
color red, peptide_1t4f_p
show_as cartoon, all
orient
show sticks, sc. and peptide_1t4f_p
symexp unbound_sym, 1t4e_unbound, (1t4e_unbound), 5.0
symexp bound_sym, 1t4f_bound, (1t4f_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1t4f, 1t4f_bound and not polymer and not resn HOH
select ligands_1t4e, 1t4e_unbound and not polymer and not resn HOH
show_as spheres, ligands_1t4f or ligands_1t4e
