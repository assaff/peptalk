load 1t4f.pdb, 1t4f_bound
select bound_1t4f_m, polymer and 1t4f_bound and chain m
select peptide_1t4f_p, polymer and 1t4f_bound and chain p
load 1t4e.pdb, 1t4e_unbound
select unbound_1t4e_a, polymer and 1t4e_unbound and chain a
align polymer and name ca and bound_1t4f_m, polymer and name ca and unbound_1t4e_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1t4e_a.pdb, unbound_1t4e_a
save bound_1t4f_m.pdb, bound_1t4f_m
save peptide_1t4f_p.pdb, peptide_1t4f_p
quit
