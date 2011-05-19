load 2o9v.pdb, 2o9v_bound
select bound_2o9v_a, polymer and 2o9v_bound and chain a
select peptide_2o9v_b, polymer and 2o9v_bound and chain b
load 2o9s.pdb, 2o9s_unbound
select unbound_2o9s_a, polymer and 2o9s_unbound and chain a
align polymer and name ca and bound_2o9v_a, polymer and name ca and unbound_2o9s_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2o9s_a.pdb, unbound_2o9s_a
save bound_2o9v_a.pdb, bound_2o9v_a
save peptide_2o9v_b.pdb, peptide_2o9v_b
quit
