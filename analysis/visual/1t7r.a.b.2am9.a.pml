load /vol/ek/share/pdb/t7/pdb1t7r.ent.gz, 1t7r_bound
select bound_1t7r_a, polymer and 1t7r_bound and chain a
load /vol/ek/share/pdb/am/pdb2am9.ent.gz, 2am9_unbound
select unbound_2am9_a, polymer and 2am9_unbound and chain a
align polymer and name ca and bound_1t7r_a, polymer and name ca and unbound_2am9_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1t7r_b, polymer and 1t7r_bound and chain b
deselect
color lime, 1t7r_bound
color forest, bound_1t7r_a
color cyan, 2am9_unbound
color blue, unbound_2am9_a
color red, peptide_1t7r_b
show_as cartoon, all
orient
show sticks, sc. and peptide_1t7r_b
symexp unbound_sym, 2am9_unbound, (2am9_unbound), 5.0
symexp bound_sym, 1t7r_bound, (1t7r_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1t7r, 1t7r_bound and not polymer and not resn HOH
select ligands_2am9, 2am9_unbound and not polymer and not resn HOH
show_as spheres, ligands_1t7r or ligands_2am9
