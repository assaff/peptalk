load 1jwg.pdb, 1jwg_bound
select bound_1jwg_b, polymer and 1jwg_bound and chain b
select peptide_1jwg_d, polymer and 1jwg_bound and chain d
load 1jwf.pdb, 1jwf_unbound
select unbound_1jwf_a, polymer and 1jwf_unbound and chain a
align polymer and name ca and bound_1jwg_b, polymer and name ca and unbound_1jwf_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1jwf_a.pdb, unbound_1jwf_a
save bound_1jwg_b.pdb, bound_1jwg_b
save peptide_1jwg_d.pdb, peptide_1jwg_d
quit
