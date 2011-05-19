load /vol/ek/share/pdb/cc/pdb2cch.ent.gz, 2cch_bound
select bound_2cch_ab, polymer and 2cch_bound and chain a+b
load /vol/ek/share/pdb/h1/pdb1h1r.ent.gz, 1h1r_unbound
select unbound_1h1r_ab, polymer and 1h1r_unbound and chain a+b
align polymer and name ca and bound_2cch_ab, polymer and name ca and unbound_1h1r_ab, quiet=0, object="aln_bound_unbound", reset=1
select peptide_2cch_e, polymer and 2cch_bound and chain e
deselect
color lime, 2cch_bound
color forest, bound_2cch_ab
color cyan, 1h1r_unbound
color blue, unbound_1h1r_ab
color red, peptide_2cch_e
show_as cartoon, all
orient
show sticks, sc. and peptide_2cch_e
symexp unbound_sym, 1h1r_unbound, (1h1r_unbound), 5.0
symexp bound_sym, 2cch_bound, (2cch_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_2cch, 2cch_bound and not polymer and not resn HOH
select ligands_1h1r, 1h1r_unbound and not polymer and not resn HOH
show_as spheres, ligands_2cch or ligands_1h1r
