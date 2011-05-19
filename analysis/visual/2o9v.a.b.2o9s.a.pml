load /vol/ek/share/pdb/o9/pdb2o9v.ent.gz, 2o9v_bound
select bound_2o9v_a, polymer and 2o9v_bound and chain a
load /vol/ek/share/pdb/o9/pdb2o9s.ent.gz, 2o9s_unbound
select unbound_2o9s_a, polymer and 2o9s_unbound and chain a
align polymer and name ca and bound_2o9v_a, polymer and name ca and unbound_2o9s_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_2o9v_b, polymer and 2o9v_bound and chain b
deselect
color lime, 2o9v_bound
color forest, bound_2o9v_a
color cyan, 2o9s_unbound
color blue, unbound_2o9s_a
color red, peptide_2o9v_b
show_as cartoon, all
orient
show sticks, sc. and peptide_2o9v_b
symexp unbound_sym, 2o9s_unbound, (2o9s_unbound), 5.0
symexp bound_sym, 2o9v_bound, (2o9v_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_2o9v, 2o9v_bound and not polymer and not resn HOH
select ligands_2o9s, 2o9s_unbound and not polymer and not resn HOH
show_as spheres, ligands_2o9v or ligands_2o9s
