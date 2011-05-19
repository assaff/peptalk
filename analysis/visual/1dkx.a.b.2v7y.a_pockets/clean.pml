load 1dkx.pdb, 1dkx_bound
select bound_1dkx_a, polymer and 1dkx_bound and chain a
select peptide_1dkx_b, polymer and 1dkx_bound and chain b
load 2v7y.pdb, 2v7y_unbound
select unbound_2v7y_a, polymer and 2v7y_unbound and chain a
align polymer and name ca and bound_1dkx_a, polymer and name ca and unbound_2v7y_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2v7y_a.pdb, unbound_2v7y_a
save bound_1dkx_a.pdb, bound_1dkx_a
save peptide_1dkx_b.pdb, peptide_1dkx_b
quit
