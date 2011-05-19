load /vol/ek/share/pdb/ho/pdb2ho2.ent.gz, 2ho2_bound
select bound_2ho2_a, polymer and 2ho2_bound and chain a
load /vol/ek/share/pdb/id/pdb2idh.ent.gz, 2idh_unbound
select unbound_2idh_a, polymer and 2idh_unbound and chain a
align polymer and name ca and bound_2ho2_a, polymer and name ca and unbound_2idh_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_2ho2_b, polymer and 2ho2_bound and chain b
deselect
color lime, 2ho2_bound
color forest, bound_2ho2_a
color cyan, 2idh_unbound
color blue, unbound_2idh_a
color red, peptide_2ho2_b
show_as cartoon, all
orient
show sticks, sc. and peptide_2ho2_b
symexp unbound_sym, 2idh_unbound, (2idh_unbound), 5.0
symexp bound_sym, 2ho2_bound, (2ho2_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_2ho2, 2ho2_bound and not polymer and not resn HOH
select ligands_2idh, 2idh_unbound and not polymer and not resn HOH
show_as spheres, ligands_2ho2 or ligands_2idh
