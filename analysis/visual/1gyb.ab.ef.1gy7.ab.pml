load /vol/ek/share/pdb/gy/pdb1gyb.ent.gz, 1gyb_bound
select bound_1gyb_ab, polymer and 1gyb_bound and chain a+b
load /vol/ek/share/pdb/gy/pdb1gy7.ent.gz, 1gy7_unbound
select unbound_1gy7_ab, polymer and 1gy7_unbound and chain a+b
align polymer and name ca and bound_1gyb_ab, polymer and name ca and unbound_1gy7_ab, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1gyb_ef, polymer and 1gyb_bound and chain e+f
deselect
color lime, 1gyb_bound
color forest, bound_1gyb_ab
color cyan, 1gy7_unbound
color blue, unbound_1gy7_ab
color red, peptide_1gyb_ef
show_as cartoon, all
orient
show sticks, sc. and peptide_1gyb_ef
symexp unbound_sym, 1gy7_unbound, (1gy7_unbound), 5.0
symexp bound_sym, 1gyb_bound, (1gyb_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1gyb, 1gyb_bound and not polymer and not resn HOH
select ligands_1gy7, 1gy7_unbound and not polymer and not resn HOH
show_as spheres, ligands_1gyb or ligands_1gy7
