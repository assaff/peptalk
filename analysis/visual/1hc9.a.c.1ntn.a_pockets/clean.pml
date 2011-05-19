load 1hc9.pdb, 1hc9_bound
select bound_1hc9_a, polymer and 1hc9_bound and chain a
select peptide_1hc9_c, polymer and 1hc9_bound and chain c
load 1ntn.pdb, 1ntn_unbound
select unbound_1ntn_a, polymer and 1ntn_unbound and chain a
align polymer and name ca and bound_1hc9_a, polymer and name ca and unbound_1ntn_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1ntn_a.pdb, unbound_1ntn_a
save bound_1hc9_a.pdb, bound_1hc9_a
save peptide_1hc9_c.pdb, peptide_1hc9_c
quit
