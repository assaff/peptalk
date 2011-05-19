load /vol/ek/share/pdb/fv/pdb2fvj.ent.gz, 2fvj_bound
select bound_2fvj_a, polymer and 2fvj_bound and chain a
load /vol/ek/share/pdb/hw/pdb2hwq.ent.gz, 2hwq_unbound
select unbound_2hwq_a, polymer and 2hwq_unbound and chain a
align polymer and name ca and bound_2fvj_a, polymer and name ca and unbound_2hwq_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_2fvj_b, polymer and 2fvj_bound and chain b
deselect
color lime, 2fvj_bound
color forest, bound_2fvj_a
color cyan, 2hwq_unbound
color blue, unbound_2hwq_a
color red, peptide_2fvj_b
show_as cartoon, all
orient
show sticks, sc. and peptide_2fvj_b
symexp unbound_sym, 2hwq_unbound, (2hwq_unbound), 5.0
symexp bound_sym, 2fvj_bound, (2fvj_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_2fvj, 2fvj_bound and not polymer and not resn HOH
select ligands_2hwq, 2hwq_unbound and not polymer and not resn HOH
show_as spheres, ligands_2fvj or ligands_2hwq
