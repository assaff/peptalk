load /vol/ek/share/pdb/se/pdb1se0.ent.gz, 1se0_bound
select bound_1se0_a, polymer and 1se0_bound and chain a
load /vol/ek/share/pdb/c9/pdb1c9q.ent.gz, 1c9q_unbound
select unbound_1c9q_a, polymer and 1c9q_unbound and chain a
align polymer and name ca and bound_1se0_a, polymer and name ca and unbound_1c9q_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1se0_b, polymer and 1se0_bound and chain b
deselect
color lime, 1se0_bound
color forest, bound_1se0_a
color cyan, 1c9q_unbound
color blue, unbound_1c9q_a
color red, peptide_1se0_b
show_as cartoon, all
orient
show sticks, sc. and peptide_1se0_b
symexp unbound_sym, 1c9q_unbound, (1c9q_unbound), 5.0
symexp bound_sym, 1se0_bound, (1se0_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1se0, 1se0_bound and not polymer and not resn HOH
select ligands_1c9q, 1c9q_unbound and not polymer and not resn HOH
show_as spheres, ligands_1se0 or ligands_1c9q
