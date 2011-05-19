load /vol/ek/share/pdb/nx/pdb1nx1.ent.gz, 1nx1_bound
select bound_1nx1_ab, polymer and 1nx1_bound and chain a+b
load /vol/ek/share/pdb/al/pdb1alv.ent.gz, 1alv_unbound
select unbound_1alv_ab, polymer and 1alv_unbound and chain a+b
align polymer and name ca and bound_1nx1_ab, polymer and name ca and unbound_1alv_ab, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1nx1_cd, polymer and 1nx1_bound and chain c+d
deselect
color lime, 1nx1_bound
color forest, bound_1nx1_ab
color cyan, 1alv_unbound
color blue, unbound_1alv_ab
color red, peptide_1nx1_cd
show_as cartoon, all
orient
show sticks, sc. and peptide_1nx1_cd
symexp unbound_sym, 1alv_unbound, (1alv_unbound), 5.0
symexp bound_sym, 1nx1_bound, (1nx1_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1nx1, 1nx1_bound and not polymer and not resn HOH
select ligands_1alv, 1alv_unbound and not polymer and not resn HOH
show_as spheres, ligands_1nx1 or ligands_1alv
