load 2foj.pdb, 2foj_bound
select bound_2foj_a, polymer and 2foj_bound and chain a
select peptide_2foj_b, polymer and 2foj_bound and chain b
load 2f1w.pdb, 2f1w_unbound
select unbound_2f1w_a, polymer and 2f1w_unbound and chain a
align polymer and name ca and bound_2foj_a, polymer and name ca and unbound_2f1w_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2f1w_a.pdb, unbound_2f1w_a
save bound_2foj_a.pdb, bound_2foj_a
save peptide_2foj_b.pdb, peptide_2foj_b
quit
