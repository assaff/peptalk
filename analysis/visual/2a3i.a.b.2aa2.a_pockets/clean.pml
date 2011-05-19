load 2a3i.pdb, 2a3i_bound
select bound_2a3i_a, polymer and 2a3i_bound and chain a
select peptide_2a3i_b, polymer and 2a3i_bound and chain b
load 2aa2.pdb, 2aa2_unbound
select unbound_2aa2_a, polymer and 2aa2_unbound and chain a
align polymer and name ca and bound_2a3i_a, polymer and name ca and unbound_2aa2_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2aa2_a.pdb, unbound_2aa2_a
save bound_2a3i_a.pdb, bound_2a3i_a
save peptide_2a3i_b.pdb, peptide_2a3i_b
quit
