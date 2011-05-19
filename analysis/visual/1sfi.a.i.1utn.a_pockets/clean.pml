load 1sfi.pdb, 1sfi_bound
select bound_1sfi_a, polymer and 1sfi_bound and chain a
select peptide_1sfi_i, polymer and 1sfi_bound and chain i
load 1utn.pdb, 1utn_unbound
select unbound_1utn_a, polymer and 1utn_unbound and chain a
align polymer and name ca and bound_1sfi_a, polymer and name ca and unbound_1utn_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1utn_a.pdb, unbound_1utn_a
save bound_1sfi_a.pdb, bound_1sfi_a
save peptide_1sfi_i.pdb, peptide_1sfi_i
quit
