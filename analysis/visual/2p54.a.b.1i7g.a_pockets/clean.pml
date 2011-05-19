load 2p54.pdb, 2p54_bound
select bound_2p54_a, polymer and 2p54_bound and chain a
select peptide_2p54_b, polymer and 2p54_bound and chain b
load 1i7g.pdb, 1i7g_unbound
select unbound_1i7g_a, polymer and 1i7g_unbound and chain a
align polymer and name ca and bound_2p54_a, polymer and name ca and unbound_1i7g_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1i7g_a.pdb, unbound_1i7g_a
save bound_2p54_a.pdb, bound_2p54_a
save peptide_2p54_b.pdb, peptide_2p54_b
quit
