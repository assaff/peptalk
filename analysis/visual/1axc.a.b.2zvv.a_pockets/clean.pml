load 1axc.pdb, 1axc_bound
select bound_1axc_a, polymer and 1axc_bound and chain a
select peptide_1axc_b, polymer and 1axc_bound and chain b
load 2zvv.pdb, 2zvv_unbound
select unbound_2zvv_a, polymer and 2zvv_unbound and chain a
align polymer and name ca and bound_1axc_a, polymer and name ca and unbound_2zvv_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2zvv_a.pdb, unbound_2zvv_a
save bound_1axc_a.pdb, bound_1axc_a
save peptide_1axc_b.pdb, peptide_1axc_b
quit
