load /vol/ek/share/pdb/hc/pdb1hc9.ent.gz, 1hc9_bound
select bound_1hc9_a, polymer and 1hc9_bound and chain a
load /vol/ek/share/pdb/nt/pdb1ntn.ent.gz, 1ntn_unbound
select unbound_1ntn_a, polymer and 1ntn_unbound and chain a
align polymer and name ca and bound_1hc9_a, polymer and name ca and unbound_1ntn_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1hc9_c, polymer and 1hc9_bound and chain c
deselect
color lime, 1hc9_bound
color forest, bound_1hc9_a
color cyan, 1ntn_unbound
color blue, unbound_1ntn_a
color red, peptide_1hc9_c
show_as cartoon, all
orient
show sticks, sc. and peptide_1hc9_c
symexp unbound_sym, 1ntn_unbound, (1ntn_unbound), 5.0
symexp bound_sym, 1hc9_bound, (1hc9_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1hc9, 1hc9_bound and not polymer and not resn HOH
select ligands_1ntn, 1ntn_unbound and not polymer and not resn HOH
show_as spheres, ligands_1hc9 or ligands_1ntn
