load 1cka.pdb, 1cka_bound
select bound_1cka_a, polymer and 1cka_bound and chain a
select peptide_1cka_b, polymer and 1cka_bound and chain b
load 2dvj.pdb, 2dvj_unbound
select unbound_2dvj_a, polymer and 2dvj_unbound and chain a
align polymer and name ca and bound_1cka_a, polymer and name ca and unbound_2dvj_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2dvj_a.pdb, unbound_2dvj_a
save bound_1cka_a.pdb, bound_1cka_a
save peptide_1cka_b.pdb, peptide_1cka_b
quit
