load /vol/ek/share/pdb/mf/pdb1mfg.ent.gz, 1mfg_bound
select bound_1mfg_a, polymer and 1mfg_bound and chain a
load /vol/ek/share/pdb/h3/pdb2h3l.ent.gz, 2h3l_unbound
select unbound_2h3l_a, polymer and 2h3l_unbound and chain a
align polymer and name ca and bound_1mfg_a, polymer and name ca and unbound_2h3l_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1mfg_b, polymer and 1mfg_bound and chain b
deselect
color lime, 1mfg_bound
color forest, bound_1mfg_a
color cyan, 2h3l_unbound
color blue, unbound_2h3l_a
color red, peptide_1mfg_b
show_as cartoon, all
orient
show sticks, sc. and peptide_1mfg_b
symexp unbound_sym, 2h3l_unbound, (2h3l_unbound), 5.0
symexp bound_sym, 1mfg_bound, (1mfg_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1mfg, 1mfg_bound and not polymer and not resn HOH
select ligands_2h3l, 2h3l_unbound and not polymer and not resn HOH
show_as spheres, ligands_1mfg or ligands_2h3l
