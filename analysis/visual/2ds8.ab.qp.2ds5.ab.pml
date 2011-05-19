load /vol/ek/share/pdb/ds/pdb2ds8.ent.gz, 2ds8_bound
select bound_2ds8_ab, polymer and 2ds8_bound and chain a+b
load /vol/ek/share/pdb/ds/pdb2ds5.ent.gz, 2ds5_unbound
select unbound_2ds5_ab, polymer and 2ds5_unbound and chain a+b
align polymer and name ca and bound_2ds8_ab, polymer and name ca and unbound_2ds5_ab, quiet=0, object="aln_bound_unbound", reset=1
select peptide_2ds8_qp, polymer and 2ds8_bound and chain q+p
deselect
color lime, 2ds8_bound
color forest, bound_2ds8_ab
color cyan, 2ds5_unbound
color blue, unbound_2ds5_ab
color red, peptide_2ds8_qp
show_as cartoon, all
orient
show sticks, sc. and peptide_2ds8_qp
symexp unbound_sym, 2ds5_unbound, (2ds5_unbound), 5.0
symexp bound_sym, 2ds8_bound, (2ds8_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_2ds8, 2ds8_bound and not polymer and not resn HOH
select ligands_2ds5, 2ds5_unbound and not polymer and not resn HOH
show_as spheres, ligands_2ds8 or ligands_2ds5
