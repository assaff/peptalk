load 2p0w.pdb, 2p0w_bound
select bound_2p0w_a, polymer and 2p0w_bound and chain a
select peptide_2p0w_p, polymer and 2p0w_bound and chain p
load 1bob.pdb, 1bob_unbound
select unbound_1bob_a, polymer and 1bob_unbound and chain a
align polymer and name ca and bound_2p0w_a, polymer and name ca and unbound_1bob_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1bob_a.pdb, unbound_1bob_a
save bound_2p0w_a.pdb, bound_2p0w_a
save peptide_2p0w_p.pdb, peptide_2p0w_p
quit
