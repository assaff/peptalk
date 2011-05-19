load 1rxz.pdb, 1rxz_bound
select bound_1rxz_a, polymer and 1rxz_bound and chain a
select peptide_1rxz_b, polymer and 1rxz_bound and chain b
load 1rwz.pdb, 1rwz_unbound
select unbound_1rwz_a, polymer and 1rwz_unbound and chain a
align polymer and name ca and bound_1rxz_a, polymer and name ca and unbound_1rwz_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1rwz_a.pdb, unbound_1rwz_a
save bound_1rxz_a.pdb, bound_1rxz_a
save peptide_1rxz_b.pdb, peptide_1rxz_b
quit
