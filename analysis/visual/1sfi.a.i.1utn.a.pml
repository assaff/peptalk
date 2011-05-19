load /vol/ek/share/pdb/sf/pdb1sfi.ent.gz, 1sfi_bound
select bound_1sfi_a, polymer and 1sfi_bound and chain a
load /vol/ek/share/pdb/ut/pdb1utn.ent.gz, 1utn_unbound
select unbound_1utn_a, polymer and 1utn_unbound and chain a
align polymer and name ca and bound_1sfi_a, polymer and name ca and unbound_1utn_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1sfi_i, polymer and 1sfi_bound and chain i
deselect
color lime, 1sfi_bound
color forest, bound_1sfi_a
color cyan, 1utn_unbound
color blue, unbound_1utn_a
color red, peptide_1sfi_i
show_as cartoon, all
orient
show sticks, sc. and peptide_1sfi_i
symexp unbound_sym, 1utn_unbound, (1utn_unbound), 5.0
symexp bound_sym, 1sfi_bound, (1sfi_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1sfi, 1sfi_bound and not polymer and not resn HOH
select ligands_1utn, 1utn_unbound and not polymer and not resn HOH
show_as spheres, ligands_1sfi or ligands_1utn
