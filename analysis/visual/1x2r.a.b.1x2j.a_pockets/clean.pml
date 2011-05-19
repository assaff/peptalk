load 1x2r.pdb, 1x2r_bound
select bound_1x2r_a, polymer and 1x2r_bound and chain a
select peptide_1x2r_b, polymer and 1x2r_bound and chain b
load 1x2j.pdb, 1x2j_unbound
select unbound_1x2j_a, polymer and 1x2j_unbound and chain a
align polymer and name ca and bound_1x2r_a, polymer and name ca and unbound_1x2j_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1x2j_a.pdb, unbound_1x2j_a
save bound_1x2r_a.pdb, bound_1x2r_a
save peptide_1x2r_b.pdb, peptide_1x2r_b
quit
