load /vol/ek/share/pdb/rx/pdb1rxz.ent.gz, 1rxz_bound
select bound_1rxz_a, polymer and 1rxz_bound and chain a
load /vol/ek/share/pdb/rw/pdb1rwz.ent.gz, 1rwz_unbound
select unbound_1rwz_a, polymer and 1rwz_unbound and chain a
align polymer and name ca and bound_1rxz_a, polymer and name ca and unbound_1rwz_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1rxz_b, polymer and 1rxz_bound and chain b
deselect
color lime, 1rxz_bound
color forest, bound_1rxz_a
color cyan, 1rwz_unbound
color blue, unbound_1rwz_a
color red, peptide_1rxz_b
show_as cartoon, all
orient
show sticks, sc. and peptide_1rxz_b
symexp unbound_sym, 1rwz_unbound, (1rwz_unbound), 5.0
symexp bound_sym, 1rxz_bound, (1rxz_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1rxz, 1rxz_bound and not polymer and not resn HOH
select ligands_1rwz, 1rwz_unbound and not polymer and not resn HOH
show_as spheres, ligands_1rxz or ligands_1rwz
