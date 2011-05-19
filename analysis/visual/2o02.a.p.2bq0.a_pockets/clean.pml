load 2o02.pdb, 2o02_bound
select bound_2o02_a, polymer and 2o02_bound and chain a
select peptide_2o02_p, polymer and 2o02_bound and chain p
load 2bq0.pdb, 2bq0_unbound
select unbound_2bq0_a, polymer and 2bq0_unbound and chain a
align polymer and name ca and bound_2o02_a, polymer and name ca and unbound_2bq0_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2bq0_a.pdb, unbound_2bq0_a
save bound_2o02_a.pdb, bound_2o02_a
save peptide_2o02_p.pdb, peptide_2o02_p
quit
