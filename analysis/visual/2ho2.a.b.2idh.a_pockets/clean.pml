load 2ho2.pdb, 2ho2_bound
select bound_2ho2_a, polymer and 2ho2_bound and chain a
select peptide_2ho2_b, polymer and 2ho2_bound and chain b
load 2idh.pdb, 2idh_unbound
select unbound_2idh_a, polymer and 2idh_unbound and chain a
align polymer and name ca and bound_2ho2_a, polymer and name ca and unbound_2idh_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2idh_a.pdb, unbound_2idh_a
save bound_2ho2_a.pdb, bound_2ho2_a
save peptide_2ho2_b.pdb, peptide_2ho2_b
quit
