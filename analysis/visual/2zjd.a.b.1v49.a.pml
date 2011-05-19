load /vol/ek/share/pdb/zj/pdb2zjd.ent.gz, 2zjd_bound
select bound_2zjd_a, polymer and 2zjd_bound and chain a
load /vol/ek/share/pdb/v4/pdb1v49.ent.gz, 1v49_unbound
select unbound_1v49_a, polymer and 1v49_unbound and chain a
align polymer and name ca and bound_2zjd_a, polymer and name ca and unbound_1v49_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_2zjd_b, polymer and 2zjd_bound and chain b
deselect
color lime, 2zjd_bound
color forest, bound_2zjd_a
color cyan, 1v49_unbound
color blue, unbound_1v49_a
color red, peptide_2zjd_b
show_as cartoon, all
orient
show sticks, sc. and peptide_2zjd_b
symexp unbound_sym, 1v49_unbound, (1v49_unbound), 5.0
symexp bound_sym, 2zjd_bound, (2zjd_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_2zjd, 2zjd_bound and not polymer and not resn HOH
select ligands_1v49, 1v49_unbound and not polymer and not resn HOH
show_as spheres, ligands_2zjd or ligands_1v49
