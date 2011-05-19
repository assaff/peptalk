load 1oai.pdb, 1oai_bound
select bound_1oai_a, polymer and 1oai_bound and chain a
select peptide_1oai_b, polymer and 1oai_bound and chain b
load 1go5.pdb, 1go5_unbound
select unbound_1go5_a, polymer and 1go5_unbound and chain a
align polymer and name ca and bound_1oai_a, polymer and name ca and unbound_1go5_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1go5_a.pdb, unbound_1go5_a
save bound_1oai_a.pdb, bound_1oai_a
save peptide_1oai_b.pdb, peptide_1oai_b
quit
