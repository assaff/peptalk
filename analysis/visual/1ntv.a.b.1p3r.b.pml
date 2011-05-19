load /vol/ek/share/pdb/nt/pdb1ntv.ent.gz, 1ntv_bound
select bound_1ntv_a, polymer and 1ntv_bound and chain a
load /vol/ek/share/pdb/p3/pdb1p3r.ent.gz, 1p3r_unbound
select unbound_1p3r_b, polymer and 1p3r_unbound and chain b
align polymer and name ca and bound_1ntv_a, polymer and name ca and unbound_1p3r_b, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1ntv_b, polymer and 1ntv_bound and chain b
deselect
color lime, 1ntv_bound
color forest, bound_1ntv_a
color cyan, 1p3r_unbound
color blue, unbound_1p3r_b
color red, peptide_1ntv_b
show_as cartoon, all
orient
show sticks, sc. and peptide_1ntv_b
symexp unbound_sym, 1p3r_unbound, (1p3r_unbound), 5.0
symexp bound_sym, 1ntv_bound, (1ntv_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1ntv, 1ntv_bound and not polymer and not resn HOH
select ligands_1p3r, 1p3r_unbound and not polymer and not resn HOH
show_as spheres, ligands_1ntv or ligands_1p3r
