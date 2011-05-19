load 2b9h.pdb, 2b9h_bound
select bound_2b9h_a, polymer and 2b9h_bound and chain a
select peptide_2b9h_c, polymer and 2b9h_bound and chain c
load 2b9f.pdb, 2b9f_unbound
select unbound_2b9f_a, polymer and 2b9f_unbound and chain a
align polymer and name ca and bound_2b9h_a, polymer and name ca and unbound_2b9f_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2b9f_a.pdb, unbound_2b9f_a
save bound_2b9h_a.pdb, bound_2b9h_a
save peptide_2b9h_c.pdb, peptide_2b9h_c
quit
