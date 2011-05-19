load /vol/ek/share/pdb/o0/pdb2o02.ent.gz, 2o02_bound
select bound_2o02_a, polymer and 2o02_bound and chain a
load /vol/ek/share/pdb/bq/pdb2bq0.ent.gz, 2bq0_unbound
select unbound_2bq0_a, polymer and 2bq0_unbound and chain a
align polymer and name ca and bound_2o02_a, polymer and name ca and unbound_2bq0_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_2o02_p, polymer and 2o02_bound and chain p
deselect
color lime, 2o02_bound
color forest, bound_2o02_a
color cyan, 2bq0_unbound
color blue, unbound_2bq0_a
color red, peptide_2o02_p
show_as cartoon, all
orient
show sticks, sc. and peptide_2o02_p
symexp unbound_sym, 2bq0_unbound, (2bq0_unbound), 5.0
symexp bound_sym, 2o02_bound, (2o02_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_2o02, 2o02_bound and not polymer and not resn HOH
select ligands_2bq0, 2bq0_unbound and not polymer and not resn HOH
show_as spheres, ligands_2o02 or ligands_2bq0
