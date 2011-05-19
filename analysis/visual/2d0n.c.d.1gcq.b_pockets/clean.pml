load 2d0n.pdb, 2d0n_bound
select bound_2d0n_c, polymer and 2d0n_bound and chain c
select peptide_2d0n_d, polymer and 2d0n_bound and chain d
load 1gcq.pdb, 1gcq_unbound
select unbound_1gcq_b, polymer and 1gcq_unbound and chain b
align polymer and name ca and bound_2d0n_c, polymer and name ca and unbound_1gcq_b, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1gcq_b.pdb, unbound_1gcq_b
save bound_2d0n_c.pdb, bound_2d0n_c
save peptide_2d0n_d.pdb, peptide_2d0n_d
quit
