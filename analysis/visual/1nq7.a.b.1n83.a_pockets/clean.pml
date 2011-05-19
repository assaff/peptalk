load 1nq7.pdb, 1nq7_bound
select bound_1nq7_a, polymer and 1nq7_bound and chain a
select peptide_1nq7_b, polymer and 1nq7_bound and chain b
load 1n83.pdb, 1n83_unbound
select unbound_1n83_a, polymer and 1n83_unbound and chain a
align polymer and name ca and bound_1nq7_a, polymer and name ca and unbound_1n83_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1n83_a.pdb, unbound_1n83_a
save bound_1nq7_a.pdb, bound_1nq7_a
save peptide_1nq7_b.pdb, peptide_1nq7_b
quit
