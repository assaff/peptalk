load /vol/ek/share/pdb/jw/pdb1jwg.ent.gz, 1jwg_bound
select bound_1jwg_b, polymer and 1jwg_bound and chain b
load /vol/ek/share/pdb/jw/pdb1jwf.ent.gz, 1jwf_unbound
select unbound_1jwf_a, polymer and 1jwf_unbound and chain a
align polymer and name ca and bound_1jwg_b, polymer and name ca and unbound_1jwf_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1jwg_d, polymer and 1jwg_bound and chain d
deselect
color lime, 1jwg_bound
color forest, bound_1jwg_b
color cyan, 1jwf_unbound
color blue, unbound_1jwf_a
color red, peptide_1jwg_d
show_as cartoon, all
orient
show sticks, sc. and peptide_1jwg_d
symexp unbound_sym, 1jwf_unbound, (1jwf_unbound), 5.0
symexp bound_sym, 1jwg_bound, (1jwg_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1jwg, 1jwg_bound and not polymer and not resn HOH
select ligands_1jwf, 1jwf_unbound and not polymer and not resn HOH
show_as spheres, ligands_1jwg or ligands_1jwf
