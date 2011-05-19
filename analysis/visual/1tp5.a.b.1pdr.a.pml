load /vol/ek/share/pdb/tp/pdb1tp5.ent.gz, 1tp5_bound
select bound_1tp5_a, polymer and 1tp5_bound and chain a
load /vol/ek/share/pdb/pd/pdb1pdr.ent.gz, 1pdr_unbound
select unbound_1pdr_a, polymer and 1pdr_unbound and chain a
align polymer and name ca and bound_1tp5_a, polymer and name ca and unbound_1pdr_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1tp5_b, polymer and 1tp5_bound and chain b
deselect
color lime, 1tp5_bound
color forest, bound_1tp5_a
color cyan, 1pdr_unbound
color blue, unbound_1pdr_a
color red, peptide_1tp5_b
show_as cartoon, all
orient
show sticks, sc. and peptide_1tp5_b
symexp unbound_sym, 1pdr_unbound, (1pdr_unbound), 5.0
symexp bound_sym, 1tp5_bound, (1tp5_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1tp5, 1tp5_bound and not polymer and not resn HOH
select ligands_1pdr, 1pdr_unbound and not polymer and not resn HOH
show_as spheres, ligands_1tp5 or ligands_1pdr
