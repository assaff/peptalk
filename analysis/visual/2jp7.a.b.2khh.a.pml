load /vol/ek/share/pdb/jp/pdb2jp7.ent.gz, 2jp7_bound
select bound_2jp7_a, polymer and 2jp7_bound and chain a
load /vol/ek/share/pdb/kh/pdb2khh.ent.gz, 2khh_unbound
select unbound_2khh_a, polymer and 2khh_unbound and chain a
align polymer and name ca and bound_2jp7_a, polymer and name ca and unbound_2khh_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_2jp7_b, polymer and 2jp7_bound and chain b
deselect
color lime, 2jp7_bound
color forest, bound_2jp7_a
color cyan, 2khh_unbound
color blue, unbound_2khh_a
color red, peptide_2jp7_b
show_as cartoon, all
orient
show sticks, sc. and peptide_2jp7_b
symexp unbound_sym, 2khh_unbound, (2khh_unbound), 5.0
symexp bound_sym, 2jp7_bound, (2jp7_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_2jp7, 2jp7_bound and not polymer and not resn HOH
select ligands_2khh, 2khh_unbound and not polymer and not resn HOH
show_as spheres, ligands_2jp7 or ligands_2khh
