load /vol/ek/share/pdb/tw/pdb1tw6.ent.gz, 1tw6_bound
select bound_1tw6_b, polymer and 1tw6_bound and chain b
load /vol/ek/share/pdb/cm/pdb3cm2.ent.gz, 3cm2_unbound
select unbound_3cm2_a, polymer and 3cm2_unbound and chain a
align polymer and name ca and bound_1tw6_b, polymer and name ca and unbound_3cm2_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1tw6_d, polymer and 1tw6_bound and chain d
deselect
color lime, 1tw6_bound
color forest, bound_1tw6_b
color cyan, 3cm2_unbound
color blue, unbound_3cm2_a
color red, peptide_1tw6_d
show_as cartoon, all
orient
show sticks, sc. and peptide_1tw6_d
symexp unbound_sym, 3cm2_unbound, (3cm2_unbound), 5.0
symexp bound_sym, 1tw6_bound, (1tw6_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1tw6, 1tw6_bound and not polymer and not resn HOH
select ligands_3cm2, 3cm2_unbound and not polymer and not resn HOH
show_as spheres, ligands_1tw6 or ligands_3cm2
