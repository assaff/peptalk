load /vol/ek/share/pdb/qk/pdb1qkz.ent.gz, 1qkz_bound
select bound_1qkz_h, polymer and 1qkz_bound and chain h
load /vol/ek/share/pdb/hi/pdb1hil.ent.gz, 1hil_unbound
select unbound_1hil_b, polymer and 1hil_unbound and chain b
align polymer and name ca and bound_1qkz_h, polymer and name ca and unbound_1hil_b, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1qkz_p, polymer and 1qkz_bound and chain p
deselect
color lime, 1qkz_bound
color forest, bound_1qkz_h
color cyan, 1hil_unbound
color blue, unbound_1hil_b
color red, peptide_1qkz_p
show_as cartoon, all
orient
show sticks, sc. and peptide_1qkz_p
symexp unbound_sym, 1hil_unbound, (1hil_unbound), 5.0
symexp bound_sym, 1qkz_bound, (1qkz_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1qkz, 1qkz_bound and not polymer and not resn HOH
select ligands_1hil, 1hil_unbound and not polymer and not resn HOH
show_as spheres, ligands_1qkz or ligands_1hil
