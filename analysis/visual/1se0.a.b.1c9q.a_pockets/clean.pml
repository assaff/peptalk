load 1se0.pdb, 1se0_bound
select bound_1se0_a, polymer and 1se0_bound and chain a
select peptide_1se0_b, polymer and 1se0_bound and chain b
load 1c9q.pdb, 1c9q_unbound
select unbound_1c9q_a, polymer and 1c9q_unbound and chain a
align polymer and name ca and bound_1se0_a, polymer and name ca and unbound_1c9q_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1c9q_a.pdb, unbound_1c9q_a
save bound_1se0_a.pdb, bound_1se0_a
save peptide_1se0_b.pdb, peptide_1se0_b
quit
