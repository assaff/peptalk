load /vol/ek/share/pdb/ym/pdb1ymt.ent.gz, 1ymt_bound
select bound_1ymt_a, polymer and 1ymt_bound and chain a
load /vol/ek/share/pdb/pk/pdb1pk5.ent.gz, 1pk5_unbound
select unbound_1pk5_a, polymer and 1pk5_unbound and chain a
align polymer and name ca and bound_1ymt_a, polymer and name ca and unbound_1pk5_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1ymt_b, polymer and 1ymt_bound and chain b
deselect
color lime, 1ymt_bound
color forest, bound_1ymt_a
color cyan, 1pk5_unbound
color blue, unbound_1pk5_a
color red, peptide_1ymt_b
show_as cartoon, all
orient
show sticks, sc. and peptide_1ymt_b
symexp unbound_sym, 1pk5_unbound, (1pk5_unbound), 5.0
symexp bound_sym, 1ymt_bound, (1ymt_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1ymt, 1ymt_bound and not polymer and not resn HOH
select ligands_1pk5, 1pk5_unbound and not polymer and not resn HOH
show_as spheres, ligands_1ymt or ligands_1pk5
