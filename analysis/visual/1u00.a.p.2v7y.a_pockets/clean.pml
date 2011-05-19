load 1u00.pdb, 1u00_bound
select bound_1u00_a, polymer and 1u00_bound and chain a
select peptide_1u00_p, polymer and 1u00_bound and chain p
load 2v7y.pdb, 2v7y_unbound
select unbound_2v7y_a, polymer and 2v7y_unbound and chain a
align polymer and name ca and bound_1u00_a, polymer and name ca and unbound_2v7y_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2v7y_a.pdb, unbound_2v7y_a
save bound_1u00_a.pdb, bound_1u00_a
save peptide_1u00_p.pdb, peptide_1u00_p
quit
