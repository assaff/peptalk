load /vol/ek/share/pdb/dk/pdb1dkx.ent.gz, 1dkx_bound
select bound_1dkx_a, polymer and 1dkx_bound and chain a
load /vol/ek/share/pdb/v7/pdb2v7y.ent.gz, 2v7y_unbound
select unbound_2v7y_a, polymer and 2v7y_unbound and chain a
align polymer and name ca and bound_1dkx_a, polymer and name ca and unbound_2v7y_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1dkx_b, polymer and 1dkx_bound and chain b
deselect
color lime, 1dkx_bound
color forest, bound_1dkx_a
color cyan, 2v7y_unbound
color blue, unbound_2v7y_a
color red, peptide_1dkx_b
show_as cartoon, all
orient
show sticks, sc. and peptide_1dkx_b
symexp unbound_sym, 2v7y_unbound, (2v7y_unbound), 5.0
symexp bound_sym, 1dkx_bound, (1dkx_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1dkx, 1dkx_bound and not polymer and not resn HOH
select ligands_2v7y, 2v7y_unbound and not polymer and not resn HOH
show_as spheres, ligands_1dkx or ligands_2v7y
