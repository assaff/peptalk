load 1t7r.pdb, 1t7r_bound
select bound_1t7r_a, polymer and 1t7r_bound and chain a
select peptide_1t7r_b, polymer and 1t7r_bound and chain b
load 2am9.pdb, 2am9_unbound
select unbound_2am9_a, polymer and 2am9_unbound and chain a
align polymer and name ca and bound_1t7r_a, polymer and name ca and unbound_2am9_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2am9_a.pdb, unbound_2am9_a
save bound_1t7r_a.pdb, bound_1t7r_a
save peptide_1t7r_b.pdb, peptide_1t7r_b
quit
