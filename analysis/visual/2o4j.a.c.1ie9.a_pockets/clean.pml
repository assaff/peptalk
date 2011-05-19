load 2o4j.pdb, 2o4j_bound
select bound_2o4j_a, polymer and 2o4j_bound and chain a
select peptide_2o4j_c, polymer and 2o4j_bound and chain c
load 1ie9.pdb, 1ie9_unbound
select unbound_1ie9_a, polymer and 1ie9_unbound and chain a
align polymer and name ca and bound_2o4j_a, polymer and name ca and unbound_1ie9_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1ie9_a.pdb, unbound_1ie9_a
save bound_2o4j_a.pdb, bound_2o4j_a
save peptide_2o4j_c.pdb, peptide_2o4j_c
quit
