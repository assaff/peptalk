load /vol/ek/share/pdb/a3/pdb2a3i.ent.gz, 2a3i_bound
select bound_2a3i_a, polymer and 2a3i_bound and chain a
load /vol/ek/share/pdb/aa/pdb2aa2.ent.gz, 2aa2_unbound
select unbound_2aa2_a, polymer and 2aa2_unbound and chain a
align polymer and name ca and bound_2a3i_a, polymer and name ca and unbound_2aa2_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_2a3i_b, polymer and 2a3i_bound and chain b
deselect
color lime, 2a3i_bound
color forest, bound_2a3i_a
color cyan, 2aa2_unbound
color blue, unbound_2aa2_a
color red, peptide_2a3i_b
show_as cartoon, all
orient
show sticks, sc. and peptide_2a3i_b
symexp unbound_sym, 2aa2_unbound, (2aa2_unbound), 5.0
symexp bound_sym, 2a3i_bound, (2a3i_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_2a3i, 2a3i_bound and not polymer and not resn HOH
select ligands_2aa2, 2aa2_unbound and not polymer and not resn HOH
show_as spheres, ligands_2a3i or ligands_2aa2
