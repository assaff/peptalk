load 2c3i.pdb, 2c3i_bound
select bound_2c3i_b, polymer and 2c3i_bound and chain b
select peptide_2c3i_a, polymer and 2c3i_bound and chain a
load 2j2i.pdb, 2j2i_unbound
select unbound_2j2i_b, polymer and 2j2i_unbound and chain b
align polymer and name ca and bound_2c3i_b, polymer and name ca and unbound_2j2i_b, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2j2i_b.pdb, unbound_2j2i_b
save bound_2c3i_b.pdb, bound_2c3i_b
save peptide_2c3i_a.pdb, peptide_2c3i_a
quit
