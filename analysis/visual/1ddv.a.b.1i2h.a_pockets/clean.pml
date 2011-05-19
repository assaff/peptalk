load 1ddv.pdb, 1ddv_bound
select bound_1ddv_a, polymer and 1ddv_bound and chain a
select peptide_1ddv_b, polymer and 1ddv_bound and chain b
load 1i2h.pdb, 1i2h_unbound
select unbound_1i2h_a, polymer and 1i2h_unbound and chain a
align polymer and name ca and bound_1ddv_a, polymer and name ca and unbound_1i2h_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1i2h_a.pdb, unbound_1i2h_a
save bound_1ddv_a.pdb, bound_1ddv_a
save peptide_1ddv_b.pdb, peptide_1ddv_b
quit
