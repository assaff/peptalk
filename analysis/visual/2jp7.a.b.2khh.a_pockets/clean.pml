load 2jp7.pdb, 2jp7_bound
select bound_2jp7_a, polymer and 2jp7_bound and chain a
select peptide_2jp7_b, polymer and 2jp7_bound and chain b
load 2khh.pdb, 2khh_unbound
select unbound_2khh_a, polymer and 2khh_unbound and chain a
align polymer and name ca and bound_2jp7_a, polymer and name ca and unbound_2khh_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2khh_a.pdb, unbound_2khh_a
save bound_2jp7_a.pdb, bound_2jp7_a
save peptide_2jp7_b.pdb, peptide_2jp7_b
quit
