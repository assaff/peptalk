load /vol/ek/share/pdb/yw/pdb1ywo.ent.gz, 1ywo_bound
select bound_1ywo_a, polymer and 1ywo_bound and chain a
load /vol/ek/share/pdb/yw/pdb1ywp.ent.gz, 1ywp_unbound
select unbound_1ywp_a, polymer and 1ywp_unbound and chain a
align polymer and name ca and bound_1ywo_a, polymer and name ca and unbound_1ywp_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1ywo_p, polymer and 1ywo_bound and chain p
deselect
color lime, 1ywo_bound
color forest, bound_1ywo_a
color cyan, 1ywp_unbound
color blue, unbound_1ywp_a
color red, peptide_1ywo_p
show_as cartoon, all
orient
show sticks, sc. and peptide_1ywo_p
symexp unbound_sym, 1ywp_unbound, (1ywp_unbound), 5.0
symexp bound_sym, 1ywo_bound, (1ywo_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1ywo, 1ywo_bound and not polymer and not resn HOH
select ligands_1ywp, 1ywp_unbound and not polymer and not resn HOH
show_as spheres, ligands_1ywo or ligands_1ywp
