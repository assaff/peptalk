load 1ymt.pdb, 1ymt_bound
select bound_1ymt_a, polymer and 1ymt_bound and chain a
select peptide_1ymt_b, polymer and 1ymt_bound and chain b
load 1pk5.pdb, 1pk5_unbound
select unbound_1pk5_a, polymer and 1pk5_unbound and chain a
align polymer and name ca and bound_1ymt_a, polymer and name ca and unbound_1pk5_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1pk5_a.pdb, unbound_1pk5_a
save bound_1ymt_a.pdb, bound_1ymt_a
save peptide_1ymt_b.pdb, peptide_1ymt_b
quit
