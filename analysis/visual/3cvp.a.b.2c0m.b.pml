load /vol/ek/share/pdb/cv/pdb3cvp.ent.gz, 3cvp_bound
select bound_3cvp_a, polymer and 3cvp_bound and chain a
load /vol/ek/share/pdb/c0/pdb2c0m.ent.gz, 2c0m_unbound
select unbound_2c0m_b, polymer and 2c0m_unbound and chain b
align polymer and name ca and bound_3cvp_a, polymer and name ca and unbound_2c0m_b, quiet=0, object="aln_bound_unbound", reset=1
select peptide_3cvp_b, polymer and 3cvp_bound and chain b
deselect
color lime, 3cvp_bound
color forest, bound_3cvp_a
color cyan, 2c0m_unbound
color blue, unbound_2c0m_b
color red, peptide_3cvp_b
show_as cartoon, all
orient
show sticks, sc. and peptide_3cvp_b
symexp unbound_sym, 2c0m_unbound, (2c0m_unbound), 5.0
symexp bound_sym, 3cvp_bound, (3cvp_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_3cvp, 3cvp_bound and not polymer and not resn HOH
select ligands_2c0m, 2c0m_unbound and not polymer and not resn HOH
show_as spheres, ligands_3cvp or ligands_2c0m
