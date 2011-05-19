load 1ywo.pdb, 1ywo_bound
select bound_1ywo_a, polymer and 1ywo_bound and chain a
select peptide_1ywo_p, polymer and 1ywo_bound and chain p
load 1ywp.pdb, 1ywp_unbound
select unbound_1ywp_a, polymer and 1ywp_unbound and chain a
align polymer and name ca and bound_1ywo_a, polymer and name ca and unbound_1ywp_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1ywp_a.pdb, unbound_1ywp_a
save bound_1ywo_a.pdb, bound_1ywo_a
save peptide_1ywo_p.pdb, peptide_1ywo_p
quit
