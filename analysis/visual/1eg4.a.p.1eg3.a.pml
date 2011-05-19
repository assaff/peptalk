load /vol/ek/share/pdb/eg/pdb1eg4.ent.gz, 1eg4_bound
select bound_1eg4_a, polymer and 1eg4_bound and chain a
load /vol/ek/share/pdb/eg/pdb1eg3.ent.gz, 1eg3_unbound
select unbound_1eg3_a, polymer and 1eg3_unbound and chain a
align polymer and name ca and bound_1eg4_a, polymer and name ca and unbound_1eg3_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1eg4_p, polymer and 1eg4_bound and chain p
deselect
color lime, 1eg4_bound
color forest, bound_1eg4_a
color cyan, 1eg3_unbound
color blue, unbound_1eg3_a
color red, peptide_1eg4_p
show_as cartoon, all
orient
show sticks, sc. and peptide_1eg4_p
symexp unbound_sym, 1eg3_unbound, (1eg3_unbound), 5.0
symexp bound_sym, 1eg4_bound, (1eg4_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1eg4, 1eg4_bound and not polymer and not resn HOH
select ligands_1eg3, 1eg3_unbound and not polymer and not resn HOH
show_as spheres, ligands_1eg4 or ligands_1eg3
