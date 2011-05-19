load /vol/ek/share/pdb/jd/pdb1jd5.ent.gz, 1jd5_bound
select bound_1jd5_a, polymer and 1jd5_bound and chain a
load /vol/ek/share/pdb/jd/pdb1jd4.ent.gz, 1jd4_unbound
select unbound_1jd4_a, polymer and 1jd4_unbound and chain a
align polymer and name ca and bound_1jd5_a, polymer and name ca and unbound_1jd4_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1jd5_b, polymer and 1jd5_bound and chain b
deselect
color lime, 1jd5_bound
color forest, bound_1jd5_a
color cyan, 1jd4_unbound
color blue, unbound_1jd4_a
color red, peptide_1jd5_b
show_as cartoon, all
orient
show sticks, sc. and peptide_1jd5_b
symexp unbound_sym, 1jd4_unbound, (1jd4_unbound), 5.0
symexp bound_sym, 1jd5_bound, (1jd5_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1jd5, 1jd5_bound and not polymer and not resn HOH
select ligands_1jd4, 1jd4_unbound and not polymer and not resn HOH
show_as spheres, ligands_1jd5 or ligands_1jd4
