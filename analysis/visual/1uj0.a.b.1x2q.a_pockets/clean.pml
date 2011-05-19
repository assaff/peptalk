load 1uj0.pdb, 1uj0_bound
select bound_1uj0_a, polymer and 1uj0_bound and chain a
select peptide_1uj0_b, polymer and 1uj0_bound and chain b
load 1x2q.pdb, 1x2q_unbound
select unbound_1x2q_a, polymer and 1x2q_unbound and chain a
align polymer and name ca and bound_1uj0_a, polymer and name ca and unbound_1x2q_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1x2q_a.pdb, unbound_1x2q_a
save bound_1uj0_a.pdb, bound_1uj0_a
save peptide_1uj0_b.pdb, peptide_1uj0_b
quit
