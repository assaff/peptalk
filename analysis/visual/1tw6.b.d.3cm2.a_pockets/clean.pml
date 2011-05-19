load 1tw6.pdb, 1tw6_bound
select bound_1tw6_b, polymer and 1tw6_bound and chain b
select peptide_1tw6_d, polymer and 1tw6_bound and chain d
load 3cm2.pdb, 3cm2_unbound
select unbound_3cm2_a, polymer and 3cm2_unbound and chain a
align polymer and name ca and bound_1tw6_b, polymer and name ca and unbound_3cm2_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_3cm2_a.pdb, unbound_3cm2_a
save bound_1tw6_b.pdb, bound_1tw6_b
save peptide_1tw6_d.pdb, peptide_1tw6_d
quit
