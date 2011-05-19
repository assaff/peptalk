load /vol/ek/share/pdb/ck/pdb1cka.ent.gz, 1cka_bound
select bound_1cka_a, polymer and 1cka_bound and chain a
load /vol/ek/share/pdb/dv/pdb2dvj.ent.gz, 2dvj_unbound
select unbound_2dvj_a, polymer and 2dvj_unbound and chain a
align polymer and name ca and bound_1cka_a, polymer and name ca and unbound_2dvj_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1cka_b, polymer and 1cka_bound and chain b
deselect
color lime, 1cka_bound
color forest, bound_1cka_a
color cyan, 2dvj_unbound
color blue, unbound_2dvj_a
color red, peptide_1cka_b
show_as cartoon, all
orient
show sticks, sc. and peptide_1cka_b
symexp unbound_sym, 2dvj_unbound, (2dvj_unbound), 5.0
symexp bound_sym, 1cka_bound, (1cka_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1cka, 1cka_bound and not polymer and not resn HOH
select ligands_2dvj, 2dvj_unbound and not polymer and not resn HOH
show_as spheres, ligands_1cka or ligands_2dvj
