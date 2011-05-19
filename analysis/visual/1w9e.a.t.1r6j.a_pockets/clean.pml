load 1w9e.pdb, 1w9e_bound
select bound_1w9e_a, polymer and 1w9e_bound and chain a
select peptide_1w9e_t, polymer and 1w9e_bound and chain t
load 1r6j.pdb, 1r6j_unbound
select unbound_1r6j_a, polymer and 1r6j_unbound and chain a
align polymer and name ca and bound_1w9e_a, polymer and name ca and unbound_1r6j_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1r6j_a.pdb, unbound_1r6j_a
save bound_1w9e_a.pdb, bound_1w9e_a
save peptide_1w9e_t.pdb, peptide_1w9e_t
quit
