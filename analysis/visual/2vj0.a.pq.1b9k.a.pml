load /vol/ek/share/pdb/vj/pdb2vj0.ent.gz, 2vj0_bound
select bound_2vj0_a, polymer and 2vj0_bound and chain a
load /vol/ek/share/pdb/b9/pdb1b9k.ent.gz, 1b9k_unbound
select unbound_1b9k_a, polymer and 1b9k_unbound and chain a
align polymer and name ca and bound_2vj0_a, polymer and name ca and unbound_1b9k_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_2vj0_pq, polymer and 2vj0_bound and chain p+q
deselect
color lime, 2vj0_bound
color forest, bound_2vj0_a
color cyan, 1b9k_unbound
color blue, unbound_1b9k_a
color red, peptide_2vj0_pq
show_as cartoon, all
orient
show sticks, sc. and peptide_2vj0_pq
symexp unbound_sym, 1b9k_unbound, (1b9k_unbound), 5.0
symexp bound_sym, 2vj0_bound, (2vj0_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_2vj0, 2vj0_bound and not polymer and not resn HOH
select ligands_1b9k, 1b9k_unbound and not polymer and not resn HOH
show_as spheres, ligands_2vj0 or ligands_1b9k
