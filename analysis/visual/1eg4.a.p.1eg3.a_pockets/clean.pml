load 1eg4.pdb, 1eg4_bound
select bound_1eg4_a, polymer and 1eg4_bound and chain a
select peptide_1eg4_p, polymer and 1eg4_bound and chain p
load 1eg3.pdb, 1eg3_unbound
select unbound_1eg3_a, polymer and 1eg3_unbound and chain a
align polymer and name ca and bound_1eg4_a, polymer and name ca and unbound_1eg3_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1eg3_a.pdb, unbound_1eg3_a
save bound_1eg4_a.pdb, bound_1eg4_a
save peptide_1eg4_p.pdb, peptide_1eg4_p
quit
