load /vol/ek/share/pdb/er/pdb1er8.ent.gz, 1er8_bound
select bound_1er8_e, polymer and 1er8_bound and chain e
load /vol/ek/share/pdb/oe/pdb1oew.ent.gz, 1oew_unbound
select unbound_1oew_a, polymer and 1oew_unbound and chain a
align polymer and name ca and bound_1er8_e, polymer and name ca and unbound_1oew_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1er8_i, polymer and 1er8_bound and chain i
deselect
color lime, 1er8_bound
color forest, bound_1er8_e
color cyan, 1oew_unbound
color blue, unbound_1oew_a
color red, peptide_1er8_i
show_as cartoon, all
orient
show sticks, sc. and peptide_1er8_i
symexp unbound_sym, 1oew_unbound, (1oew_unbound), 5.0
symexp bound_sym, 1er8_bound, (1er8_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1er8, 1er8_bound and not polymer and not resn HOH
select ligands_1oew, 1oew_unbound and not polymer and not resn HOH
show_as spheres, ligands_1er8 or ligands_1oew
