load 1er8.pdb, 1er8_bound
select bound_1er8_e, polymer and 1er8_bound and chain e
select peptide_1er8_i, polymer and 1er8_bound and chain i
load 1oew.pdb, 1oew_unbound
select unbound_1oew_a, polymer and 1oew_unbound and chain a
align polymer and name ca and bound_1er8_e, polymer and name ca and unbound_1oew_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1oew_a.pdb, unbound_1oew_a
save bound_1er8_e.pdb, bound_1er8_e
save peptide_1er8_i.pdb, peptide_1er8_i
quit
