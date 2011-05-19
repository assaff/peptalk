load 2puy.pdb, 2puy_bound
select bound_2puy_b, polymer and 2puy_bound and chain b
select peptide_2puy_e, polymer and 2puy_bound and chain e
load 2yql.pdb, 2yql_unbound
select unbound_2yql_a, polymer and 2yql_unbound and chain a
align polymer and name ca and bound_2puy_b, polymer and name ca and unbound_2yql_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2yql_a.pdb, unbound_2yql_a
save bound_2puy_b.pdb, bound_2puy_b
save peptide_2puy_e.pdb, peptide_2puy_e
quit
