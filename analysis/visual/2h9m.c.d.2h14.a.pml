load /vol/ek/share/pdb/h9/pdb2h9m.ent.gz, 2h9m_bound
select bound_2h9m_c, polymer and 2h9m_bound and chain c
load /vol/ek/share/pdb/h1/pdb2h14.ent.gz, 2h14_unbound
select unbound_2h14_a, polymer and 2h14_unbound and chain a
align polymer and name ca and bound_2h9m_c, polymer and name ca and unbound_2h14_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_2h9m_d, polymer and 2h9m_bound and chain d
deselect
color lime, 2h9m_bound
color forest, bound_2h9m_c
color cyan, 2h14_unbound
color blue, unbound_2h14_a
color red, peptide_2h9m_d
show_as cartoon, all
orient
show sticks, sc. and peptide_2h9m_d
symexp unbound_sym, 2h14_unbound, (2h14_unbound), 5.0
symexp bound_sym, 2h9m_bound, (2h9m_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_2h9m, 2h9m_bound and not polymer and not resn HOH
select ligands_2h14, 2h14_unbound and not polymer and not resn HOH
show_as spheres, ligands_2h9m or ligands_2h14
