load /vol/ek/share/pdb/fo/pdb2foj.ent.gz, 2foj_bound
select bound_2foj_a, polymer and 2foj_bound and chain a
load /vol/ek/share/pdb/f1/pdb2f1w.ent.gz, 2f1w_unbound
select unbound_2f1w_a, polymer and 2f1w_unbound and chain a
align polymer and name ca and bound_2foj_a, polymer and name ca and unbound_2f1w_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_2foj_b, polymer and 2foj_bound and chain b
deselect
color lime, 2foj_bound
color forest, bound_2foj_a
color cyan, 2f1w_unbound
color blue, unbound_2f1w_a
color red, peptide_2foj_b
show_as cartoon, all
orient
show sticks, sc. and peptide_2foj_b
symexp unbound_sym, 2f1w_unbound, (2f1w_unbound), 5.0
symexp bound_sym, 2foj_bound, (2foj_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_2foj, 2foj_bound and not polymer and not resn HOH
select ligands_2f1w, 2f1w_unbound and not polymer and not resn HOH
show_as spheres, ligands_2foj or ligands_2f1w
