load /vol/ek/share/pdb/c3/pdb2c3i.ent.gz, 2c3i_bound
select bound_2c3i_b, polymer and 2c3i_bound and chain b
load /vol/ek/share/pdb/j2/pdb2j2i.ent.gz, 2j2i_unbound
select unbound_2j2i_b, polymer and 2j2i_unbound and chain b
align polymer and name ca and bound_2c3i_b, polymer and name ca and unbound_2j2i_b, quiet=0, object="aln_bound_unbound", reset=1
select peptide_2c3i_a, polymer and 2c3i_bound and chain a
deselect
color lime, 2c3i_bound
color forest, bound_2c3i_b
color cyan, 2j2i_unbound
color blue, unbound_2j2i_b
color red, peptide_2c3i_a
show_as cartoon, all
orient
show sticks, sc. and peptide_2c3i_a
symexp unbound_sym, 2j2i_unbound, (2j2i_unbound), 5.0
symexp bound_sym, 2c3i_bound, (2c3i_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_2c3i, 2c3i_bound and not polymer and not resn HOH
select ligands_2j2i, 2j2i_unbound and not polymer and not resn HOH
show_as spheres, ligands_2c3i or ligands_2j2i
