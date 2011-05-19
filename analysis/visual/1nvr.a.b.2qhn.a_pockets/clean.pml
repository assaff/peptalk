load 1nvr.pdb, 1nvr_bound
select bound_1nvr_a, polymer and 1nvr_bound and chain a
select peptide_1nvr_b, polymer and 1nvr_bound and chain b
load 2qhn.pdb, 2qhn_unbound
select unbound_2qhn_a, polymer and 2qhn_unbound and chain a
align polymer and name ca and bound_1nvr_a, polymer and name ca and unbound_2qhn_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2qhn_a.pdb, unbound_2qhn_a
save bound_1nvr_a.pdb, bound_1nvr_a
save peptide_1nvr_b.pdb, peptide_1nvr_b
quit
