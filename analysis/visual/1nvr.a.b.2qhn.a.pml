load /vol/ek/share/pdb/nv/pdb1nvr.ent.gz, 1nvr_bound
select bound_1nvr_a, polymer and 1nvr_bound and chain a
load /vol/ek/share/pdb/qh/pdb2qhn.ent.gz, 2qhn_unbound
select unbound_2qhn_a, polymer and 2qhn_unbound and chain a
align polymer and name ca and bound_1nvr_a, polymer and name ca and unbound_2qhn_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1nvr_b, polymer and 1nvr_bound and chain b
deselect
color lime, 1nvr_bound
color forest, bound_1nvr_a
color cyan, 2qhn_unbound
color blue, unbound_2qhn_a
color red, peptide_1nvr_b
show_as cartoon, all
orient
show sticks, sc. and peptide_1nvr_b
symexp unbound_sym, 2qhn_unbound, (2qhn_unbound), 5.0
symexp bound_sym, 1nvr_bound, (1nvr_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1nvr, 1nvr_bound and not polymer and not resn HOH
select ligands_2qhn, 2qhn_unbound and not polymer and not resn HOH
show_as spheres, ligands_1nvr or ligands_2qhn
