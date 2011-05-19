load 1d4t.pdb, 1d4t_bound
select bound_1d4t_a, polymer and 1d4t_bound and chain a
select peptide_1d4t_b, polymer and 1d4t_bound and chain b
load 1d1z.pdb, 1d1z_unbound
select unbound_1d1z_a, polymer and 1d1z_unbound and chain a
align polymer and name ca and bound_1d4t_a, polymer and name ca and unbound_1d1z_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1d1z_a.pdb, unbound_1d1z_a
save bound_1d4t_a.pdb, bound_1d4t_a
save peptide_1d4t_b.pdb, peptide_1d4t_b
quit
