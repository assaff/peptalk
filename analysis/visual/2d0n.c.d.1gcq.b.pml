load /vol/ek/share/pdb/d0/pdb2d0n.ent.gz, 2d0n_bound
select bound_2d0n_c, polymer and 2d0n_bound and chain c
load /vol/ek/share/pdb/gc/pdb1gcq.ent.gz, 1gcq_unbound
select unbound_1gcq_b, polymer and 1gcq_unbound and chain b
align polymer and name ca and bound_2d0n_c, polymer and name ca and unbound_1gcq_b, quiet=0, object="aln_bound_unbound", reset=1
select peptide_2d0n_d, polymer and 2d0n_bound and chain d
deselect
color lime, 2d0n_bound
color forest, bound_2d0n_c
color cyan, 1gcq_unbound
color blue, unbound_1gcq_b
color red, peptide_2d0n_d
show_as cartoon, all
orient
show sticks, sc. and peptide_2d0n_d
symexp unbound_sym, 1gcq_unbound, (1gcq_unbound), 5.0
symexp bound_sym, 2d0n_bound, (2d0n_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_2d0n, 2d0n_bound and not polymer and not resn HOH
select ligands_1gcq, 1gcq_unbound and not polymer and not resn HOH
show_as spheres, ligands_2d0n or ligands_1gcq
