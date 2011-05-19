load 1mfg.pdb, 1mfg_bound
select bound_1mfg_a, polymer and 1mfg_bound and chain a
select peptide_1mfg_b, polymer and 1mfg_bound and chain b
load 2h3l.pdb, 2h3l_unbound
select unbound_2h3l_a, polymer and 2h3l_unbound and chain a
align polymer and name ca and bound_1mfg_a, polymer and name ca and unbound_2h3l_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2h3l_a.pdb, unbound_2h3l_a
save bound_1mfg_a.pdb, bound_1mfg_a
save peptide_1mfg_b.pdb, peptide_1mfg_b
quit
