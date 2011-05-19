load 1qkz.pdb, 1qkz_bound
select bound_1qkz_h, polymer and 1qkz_bound and chain h
select peptide_1qkz_p, polymer and 1qkz_bound and chain p
load 1hil.pdb, 1hil_unbound
select unbound_1hil_b, polymer and 1hil_unbound and chain b
align polymer and name ca and bound_1qkz_h, polymer and name ca and unbound_1hil_b, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1hil_b.pdb, unbound_1hil_b
save bound_1qkz_h.pdb, bound_1qkz_h
save peptide_1qkz_p.pdb, peptide_1qkz_p
quit
