load /vol/ek/share/pdb/w9/pdb1w9e.ent.gz, 1w9e_bound
select bound_1w9e_a, polymer and 1w9e_bound and chain a
load /vol/ek/share/pdb/r6/pdb1r6j.ent.gz, 1r6j_unbound
select unbound_1r6j_a, polymer and 1r6j_unbound and chain a
align polymer and name ca and bound_1w9e_a, polymer and name ca and unbound_1r6j_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1w9e_t, polymer and 1w9e_bound and chain t
deselect
color lime, 1w9e_bound
color forest, bound_1w9e_a
color cyan, 1r6j_unbound
color blue, unbound_1r6j_a
color red, peptide_1w9e_t
show_as cartoon, all
orient
show sticks, sc. and peptide_1w9e_t
symexp unbound_sym, 1r6j_unbound, (1r6j_unbound), 5.0
symexp bound_sym, 1w9e_bound, (1w9e_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1w9e, 1w9e_bound and not polymer and not resn HOH
select ligands_1r6j, 1r6j_unbound and not polymer and not resn HOH
show_as spheres, ligands_1w9e or ligands_1r6j
