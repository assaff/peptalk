load 2h9m.pdb, 2h9m_bound
select bound_2h9m_c, polymer and 2h9m_bound and chain c
select peptide_2h9m_d, polymer and 2h9m_bound and chain d
load 2h14.pdb, 2h14_unbound
select unbound_2h14_a, polymer and 2h14_unbound and chain a
align polymer and name ca and bound_2h9m_c, polymer and name ca and unbound_2h14_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2h14_a.pdb, unbound_2h14_a
save bound_2h9m_c.pdb, bound_2h9m_c
save peptide_2h9m_d.pdb, peptide_2h9m_d
quit
