load /vol/ek/share/pdb/fm/pdb2fmf.ent.gz, 2fmf_bound
select bound_2fmf_a, polymer and 2fmf_bound and chain a
load /vol/ek/share/pdb/jb/pdb1jbe.ent.gz, 1jbe_unbound
select unbound_1jbe_a, polymer and 1jbe_unbound and chain a
align polymer and name ca and bound_2fmf_a, polymer and name ca and unbound_1jbe_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_2fmf_b, polymer and 2fmf_bound and chain b
deselect
color lime, 2fmf_bound
color forest, bound_2fmf_a
color cyan, 1jbe_unbound
color blue, unbound_1jbe_a
color red, peptide_2fmf_b
show_as cartoon, all
orient
show sticks, sc. and peptide_2fmf_b
symexp unbound_sym, 1jbe_unbound, (1jbe_unbound), 5.0
symexp bound_sym, 2fmf_bound, (2fmf_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_2fmf, 2fmf_bound and not polymer and not resn HOH
select ligands_1jbe, 1jbe_unbound and not polymer and not resn HOH
show_as spheres, ligands_2fmf or ligands_1jbe
