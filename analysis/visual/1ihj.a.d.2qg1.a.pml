load /vol/ek/share/pdb/ih/pdb1ihj.ent.gz, 1ihj_bound
select bound_1ihj_a, polymer and 1ihj_bound and chain a
load /vol/ek/share/pdb/qg/pdb2qg1.ent.gz, 2qg1_unbound
select unbound_2qg1_a, polymer and 2qg1_unbound and chain a
align polymer and name ca and bound_1ihj_a, polymer and name ca and unbound_2qg1_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1ihj_d, polymer and 1ihj_bound and chain d
deselect
color lime, 1ihj_bound
color forest, bound_1ihj_a
color cyan, 2qg1_unbound
color blue, unbound_2qg1_a
color red, peptide_1ihj_d
show_as cartoon, all
orient
show sticks, sc. and peptide_1ihj_d
symexp unbound_sym, 2qg1_unbound, (2qg1_unbound), 5.0
symexp bound_sym, 1ihj_bound, (1ihj_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1ihj, 1ihj_bound and not polymer and not resn HOH
select ligands_2qg1, 2qg1_unbound and not polymer and not resn HOH
show_as spheres, ligands_1ihj or ligands_2qg1
