load 3cvp.pdb, 3cvp_bound
select bound_3cvp_a, polymer and 3cvp_bound and chain a
select peptide_3cvp_b, polymer and 3cvp_bound and chain b
load 2c0m.pdb, 2c0m_unbound
select unbound_2c0m_b, polymer and 2c0m_unbound and chain b
align polymer and name ca and bound_3cvp_a, polymer and name ca and unbound_2c0m_b, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2c0m_b.pdb, unbound_2c0m_b
save bound_3cvp_a.pdb, bound_3cvp_a
save peptide_3cvp_b.pdb, peptide_3cvp_b
quit
