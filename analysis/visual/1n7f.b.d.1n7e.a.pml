load /vol/ek/share/pdb/n7/pdb1n7f.ent.gz, 1n7f_bound
select bound_1n7f_b, polymer and 1n7f_bound and chain b
load /vol/ek/share/pdb/n7/pdb1n7e.ent.gz, 1n7e_unbound
select unbound_1n7e_a, polymer and 1n7e_unbound and chain a
align polymer and name ca and bound_1n7f_b, polymer and name ca and unbound_1n7e_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1n7f_d, polymer and 1n7f_bound and chain d
deselect
color lime, 1n7f_bound
color forest, bound_1n7f_b
color cyan, 1n7e_unbound
color blue, unbound_1n7e_a
color red, peptide_1n7f_d
show_as cartoon, all
orient
show sticks, sc. and peptide_1n7f_d
symexp unbound_sym, 1n7e_unbound, (1n7e_unbound), 5.0
symexp bound_sym, 1n7f_bound, (1n7f_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1n7f, 1n7f_bound and not polymer and not resn HOH
select ligands_1n7e, 1n7e_unbound and not polymer and not resn HOH
show_as spheres, ligands_1n7f or ligands_1n7e
