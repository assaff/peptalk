load /vol/ek/share/pdb/u0/pdb1u00.ent.gz, 1u00_bound
select bound_1u00_a, polymer and 1u00_bound and chain a
load /vol/ek/share/pdb/v7/pdb2v7y.ent.gz, 2v7y_unbound
select unbound_2v7y_a, polymer and 2v7y_unbound and chain a
align polymer and name ca and bound_1u00_a, polymer and name ca and unbound_2v7y_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1u00_p, polymer and 1u00_bound and chain p
deselect
color lime, 1u00_bound
color forest, bound_1u00_a
color cyan, 2v7y_unbound
color blue, unbound_2v7y_a
color red, peptide_1u00_p
show_as cartoon, all
orient
show sticks, sc. and peptide_1u00_p
symexp unbound_sym, 2v7y_unbound, (2v7y_unbound), 5.0
symexp bound_sym, 1u00_bound, (1u00_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1u00, 1u00_bound and not polymer and not resn HOH
select ligands_2v7y, 2v7y_unbound and not polymer and not resn HOH
show_as spheres, ligands_1u00 or ligands_2v7y
