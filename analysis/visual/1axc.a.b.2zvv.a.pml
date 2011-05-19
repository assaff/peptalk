load /vol/ek/share/pdb/ax/pdb1axc.ent.gz, 1axc_bound
select bound_1axc_a, polymer and 1axc_bound and chain a
load /vol/ek/share/pdb/zv/pdb2zvv.ent.gz, 2zvv_unbound
select unbound_2zvv_a, polymer and 2zvv_unbound and chain a
align polymer and name ca and bound_1axc_a, polymer and name ca and unbound_2zvv_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1axc_b, polymer and 1axc_bound and chain b
deselect
color lime, 1axc_bound
color forest, bound_1axc_a
color cyan, 2zvv_unbound
color blue, unbound_2zvv_a
color red, peptide_1axc_b
show_as cartoon, all
orient
show sticks, sc. and peptide_1axc_b
symexp unbound_sym, 2zvv_unbound, (2zvv_unbound), 5.0
symexp bound_sym, 1axc_bound, (1axc_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1axc, 1axc_bound and not polymer and not resn HOH
select ligands_2zvv, 2zvv_unbound and not polymer and not resn HOH
show_as spheres, ligands_1axc or ligands_2zvv
