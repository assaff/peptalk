load /vol/ek/share/pdb/x2/pdb1x2r.ent.gz, 1x2r_bound
select bound_1x2r_a, polymer and 1x2r_bound and chain a
load /vol/ek/share/pdb/x2/pdb1x2j.ent.gz, 1x2j_unbound
select unbound_1x2j_a, polymer and 1x2j_unbound and chain a
align polymer and name ca and bound_1x2r_a, polymer and name ca and unbound_1x2j_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1x2r_b, polymer and 1x2r_bound and chain b
deselect
color lime, 1x2r_bound
color forest, bound_1x2r_a
color cyan, 1x2j_unbound
color blue, unbound_1x2j_a
color red, peptide_1x2r_b
show_as cartoon, all
orient
show sticks, sc. and peptide_1x2r_b
symexp unbound_sym, 1x2j_unbound, (1x2j_unbound), 5.0
symexp bound_sym, 1x2r_bound, (1x2r_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1x2r, 1x2r_bound and not polymer and not resn HOH
select ligands_1x2j, 1x2j_unbound and not polymer and not resn HOH
show_as spheres, ligands_1x2r or ligands_1x2j
