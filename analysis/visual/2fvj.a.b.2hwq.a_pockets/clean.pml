load 2fvj.pdb, 2fvj_bound
select bound_2fvj_a, polymer and 2fvj_bound and chain a
select peptide_2fvj_b, polymer and 2fvj_bound and chain b
load 2hwq.pdb, 2hwq_unbound
select unbound_2hwq_a, polymer and 2hwq_unbound and chain a
align polymer and name ca and bound_2fvj_a, polymer and name ca and unbound_2hwq_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2hwq_a.pdb, unbound_2hwq_a
save bound_2fvj_a.pdb, bound_2fvj_a
save peptide_2fvj_b.pdb, peptide_2fvj_b
quit
