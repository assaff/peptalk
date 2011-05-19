load /vol/ek/share/pdb/cz/pdb1czy.ent.gz, 1czy_bound
select bound_1czy_abc, polymer and 1czy_bound and chain a+b+c
load /vol/ek/share/pdb/ca/pdb1ca4.ent.gz, 1ca4_unbound
select unbound_1ca4_abc, polymer and 1ca4_unbound and chain a+b+c
align polymer and name ca and bound_1czy_abc, polymer and name ca and unbound_1ca4_abc, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1czy_e, polymer and 1czy_bound and chain e
deselect
color lime, 1czy_bound
color forest, bound_1czy_abc
color cyan, 1ca4_unbound
color blue, unbound_1ca4_abc
color red, peptide_1czy_e
show_as cartoon, all
orient
show sticks, sc. and peptide_1czy_e
symexp unbound_sym, 1ca4_unbound, (1ca4_unbound), 5.0
symexp bound_sym, 1czy_bound, (1czy_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1czy, 1czy_bound and not polymer and not resn HOH
select ligands_1ca4, 1ca4_unbound and not polymer and not resn HOH
show_as spheres, ligands_1czy or ligands_1ca4
