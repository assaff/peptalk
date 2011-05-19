load /vol/ek/share/pdb/o4/pdb2o4j.ent.gz, 2o4j_bound
select bound_2o4j_a, polymer and 2o4j_bound and chain a
load /vol/ek/share/pdb/ie/pdb1ie9.ent.gz, 1ie9_unbound
select unbound_1ie9_a, polymer and 1ie9_unbound and chain a
align polymer and name ca and bound_2o4j_a, polymer and name ca and unbound_1ie9_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_2o4j_c, polymer and 2o4j_bound and chain c
deselect
color lime, 2o4j_bound
color forest, bound_2o4j_a
color cyan, 1ie9_unbound
color blue, unbound_1ie9_a
color red, peptide_2o4j_c
show_as cartoon, all
orient
show sticks, sc. and peptide_2o4j_c
symexp unbound_sym, 1ie9_unbound, (1ie9_unbound), 5.0
symexp bound_sym, 2o4j_bound, (2o4j_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_2o4j, 2o4j_bound and not polymer and not resn HOH
select ligands_1ie9, 1ie9_unbound and not polymer and not resn HOH
show_as spheres, ligands_2o4j or ligands_1ie9
