load 1awr.pdb, 1awr_bound
select bound_1awr_c, polymer and 1awr_bound and chain c
select peptide_1awr_i, polymer and 1awr_bound and chain i
load 2alf.pdb, 2alf_unbound
select unbound_2alf_a, polymer and 2alf_unbound and chain a
align polymer and name ca and bound_1awr_c, polymer and name ca and unbound_2alf_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2alf_a.pdb, unbound_2alf_a
save bound_1awr_c.pdb, bound_1awr_c
save peptide_1awr_i.pdb, peptide_1awr_i
quit
