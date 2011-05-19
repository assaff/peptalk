load 2ds8.pdb, 2ds8_bound
select bound_2ds8_ab, polymer and 2ds8_bound and chain a+b
select peptide_2ds8_qp, polymer and 2ds8_bound and chain q+p
load 2ds5.pdb, 2ds5_unbound
select unbound_2ds5_ab, polymer and 2ds5_unbound and chain a+b
align polymer and name ca and bound_2ds8_ab, polymer and name ca and unbound_2ds5_ab, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2ds5_ab.pdb, unbound_2ds5_ab
save bound_2ds8_ab.pdb, bound_2ds8_ab
save peptide_2ds8_qp.pdb, peptide_2ds8_qp
quit
