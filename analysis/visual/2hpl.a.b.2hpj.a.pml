load /vol/ek/share/pdb/hp/pdb2hpl.ent.gz, 2hpl_bound
select bound_2hpl_a, polymer and 2hpl_bound and chain a
load /vol/ek/share/pdb/hp/pdb2hpj.ent.gz, 2hpj_unbound
select unbound_2hpj_a, polymer and 2hpj_unbound and chain a
align polymer and name ca and bound_2hpl_a, polymer and name ca and unbound_2hpj_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_2hpl_b, polymer and 2hpl_bound and chain b
deselect
color lime, 2hpl_bound
color forest, bound_2hpl_a
color cyan, 2hpj_unbound
color blue, unbound_2hpj_a
color red, peptide_2hpl_b
show_as cartoon, all
orient
show sticks, sc. and peptide_2hpl_b
symexp unbound_sym, 2hpj_unbound, (2hpj_unbound), 5.0
symexp bound_sym, 2hpl_bound, (2hpl_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_2hpl, 2hpl_bound and not polymer and not resn HOH
select ligands_2hpj, 2hpj_unbound and not polymer and not resn HOH
show_as spheres, ligands_2hpl or ligands_2hpj
