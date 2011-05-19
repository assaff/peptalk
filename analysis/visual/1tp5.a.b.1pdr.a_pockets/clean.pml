load 1tp5.pdb, 1tp5_bound
select bound_1tp5_a, polymer and 1tp5_bound and chain a
select peptide_1tp5_b, polymer and 1tp5_bound and chain b
load 1pdr.pdb, 1pdr_unbound
select unbound_1pdr_a, polymer and 1pdr_unbound and chain a
align polymer and name ca and bound_1tp5_a, polymer and name ca and unbound_1pdr_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1pdr_a.pdb, unbound_1pdr_a
save bound_1tp5_a.pdb, bound_1tp5_a
save peptide_1tp5_b.pdb, peptide_1tp5_b
quit
