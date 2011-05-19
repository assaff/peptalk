load 1n7f.pdb, 1n7f_bound
select bound_1n7f_b, polymer and 1n7f_bound and chain b
select peptide_1n7f_d, polymer and 1n7f_bound and chain d
load 1n7e.pdb, 1n7e_unbound
select unbound_1n7e_a, polymer and 1n7e_unbound and chain a
align polymer and name ca and bound_1n7f_b, polymer and name ca and unbound_1n7e_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1n7e_a.pdb, unbound_1n7e_a
save bound_1n7f_b.pdb, bound_1n7f_b
save peptide_1n7f_d.pdb, peptide_1n7f_d
quit
