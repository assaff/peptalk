load /vol/ek/share/pdb/nq/pdb1nq7.ent.gz, 1nq7_bound
select bound_1nq7_a, polymer and 1nq7_bound and chain a
load /vol/ek/share/pdb/n8/pdb1n83.ent.gz, 1n83_unbound
select unbound_1n83_a, polymer and 1n83_unbound and chain a
align polymer and name ca and bound_1nq7_a, polymer and name ca and unbound_1n83_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1nq7_b, polymer and 1nq7_bound and chain b
deselect
color lime, 1nq7_bound
color forest, bound_1nq7_a
color cyan, 1n83_unbound
color blue, unbound_1n83_a
color red, peptide_1nq7_b
show_as cartoon, all
orient
show sticks, sc. and peptide_1nq7_b
symexp unbound_sym, 1n83_unbound, (1n83_unbound), 5.0
symexp bound_sym, 1nq7_bound, (1nq7_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1nq7, 1nq7_bound and not polymer and not resn HOH
select ligands_1n83, 1n83_unbound and not polymer and not resn HOH
show_as spheres, ligands_1nq7 or ligands_1n83
