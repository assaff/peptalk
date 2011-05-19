load /vol/ek/share/pdb/dd/pdb1ddv.ent.gz, 1ddv_bound
select bound_1ddv_a, polymer and 1ddv_bound and chain a
load /vol/ek/share/pdb/i2/pdb1i2h.ent.gz, 1i2h_unbound
select unbound_1i2h_a, polymer and 1i2h_unbound and chain a
align polymer and name ca and bound_1ddv_a, polymer and name ca and unbound_1i2h_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1ddv_b, polymer and 1ddv_bound and chain b
deselect
color lime, 1ddv_bound
color forest, bound_1ddv_a
color cyan, 1i2h_unbound
color blue, unbound_1i2h_a
color red, peptide_1ddv_b
show_as cartoon, all
orient
show sticks, sc. and peptide_1ddv_b
symexp unbound_sym, 1i2h_unbound, (1i2h_unbound), 5.0
symexp bound_sym, 1ddv_bound, (1ddv_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1ddv, 1ddv_bound and not polymer and not resn HOH
select ligands_1i2h, 1i2h_unbound and not polymer and not resn HOH
show_as spheres, ligands_1ddv or ligands_1i2h
