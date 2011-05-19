load 2vj0.pdb, 2vj0_bound
select bound_2vj0_a, polymer and 2vj0_bound and chain a
select peptide_2vj0_pq, polymer and 2vj0_bound and chain p+q
load 1b9k.pdb, 1b9k_unbound
select unbound_1b9k_a, polymer and 1b9k_unbound and chain a
align polymer and name ca and bound_2vj0_a, polymer and name ca and unbound_1b9k_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1b9k_a.pdb, unbound_1b9k_a
save bound_2vj0_a.pdb, bound_2vj0_a
save peptide_2vj0_pq.pdb, peptide_2vj0_pq
quit
