load 2zjd.pdb, 2zjd_bound
select bound_2zjd_a, polymer and 2zjd_bound and chain a
select peptide_2zjd_b, polymer and 2zjd_bound and chain b
load 1v49.pdb, 1v49_unbound
select unbound_1v49_a, polymer and 1v49_unbound and chain a
align polymer and name ca and bound_2zjd_a, polymer and name ca and unbound_1v49_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1v49_a.pdb, unbound_1v49_a
save bound_2zjd_a.pdb, bound_2zjd_a
save peptide_2zjd_b.pdb, peptide_2zjd_b
quit
