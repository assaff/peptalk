load 3d9t.pdb, 3d9t_bound
select bound_3d9t_a, polymer and 3d9t_bound and chain a
select peptide_3d9t_c, polymer and 3d9t_bound and chain c
load 2uvl.pdb, 2uvl_unbound
select unbound_2uvl_a, polymer and 2uvl_unbound and chain a
align polymer and name ca and bound_3d9t_a, polymer and name ca and unbound_2uvl_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2uvl_a.pdb, unbound_2uvl_a
save bound_3d9t_a.pdb, bound_3d9t_a
save peptide_3d9t_c.pdb, peptide_3d9t_c
quit
