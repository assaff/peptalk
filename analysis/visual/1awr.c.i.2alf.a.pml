load /vol/ek/share/pdb/aw/pdb1awr.ent.gz, 1awr_bound
select bound_1awr_c, polymer and 1awr_bound and chain c
load /vol/ek/share/pdb/al/pdb2alf.ent.gz, 2alf_unbound
select unbound_2alf_a, polymer and 2alf_unbound and chain a
align polymer and name ca and bound_1awr_c, polymer and name ca and unbound_2alf_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1awr_i, polymer and 1awr_bound and chain i
deselect
color lime, 1awr_bound
color forest, bound_1awr_c
color cyan, 2alf_unbound
color blue, unbound_2alf_a
color red, peptide_1awr_i
show_as cartoon, all
orient
show sticks, sc. and peptide_1awr_i
symexp unbound_sym, 2alf_unbound, (2alf_unbound), 5.0
symexp bound_sym, 1awr_bound, (1awr_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1awr, 1awr_bound and not polymer and not resn HOH
select ligands_2alf, 2alf_unbound and not polymer and not resn HOH
show_as spheres, ligands_1awr or ligands_2alf
