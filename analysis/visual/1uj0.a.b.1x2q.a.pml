load /vol/ek/share/pdb/uj/pdb1uj0.ent.gz, 1uj0_bound
select bound_1uj0_a, polymer and 1uj0_bound and chain a
load /vol/ek/share/pdb/x2/pdb1x2q.ent.gz, 1x2q_unbound
select unbound_1x2q_a, polymer and 1x2q_unbound and chain a
align polymer and name ca and bound_1uj0_a, polymer and name ca and unbound_1x2q_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1uj0_b, polymer and 1uj0_bound and chain b
deselect
color lime, 1uj0_bound
color forest, bound_1uj0_a
color cyan, 1x2q_unbound
color blue, unbound_1x2q_a
color red, peptide_1uj0_b
show_as cartoon, all
orient
show sticks, sc. and peptide_1uj0_b
symexp unbound_sym, 1x2q_unbound, (1x2q_unbound), 5.0
symexp bound_sym, 1uj0_bound, (1uj0_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1uj0, 1uj0_bound and not polymer and not resn HOH
select ligands_1x2q, 1x2q_unbound and not polymer and not resn HOH
show_as spheres, ligands_1uj0 or ligands_1x2q
