load 1ssh.pdb, 1ssh_bound
select bound_1ssh_a, polymer and 1ssh_bound and chain a
select peptide_1ssh_b, polymer and 1ssh_bound and chain b
load 1oot.pdb, 1oot_unbound
select unbound_1oot_a, polymer and 1oot_unbound and chain a
align polymer and name ca and bound_1ssh_a, polymer and name ca and unbound_1oot_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1oot_a.pdb, unbound_1oot_a
save bound_1ssh_a.pdb, bound_1ssh_a
save peptide_1ssh_b.pdb, peptide_1ssh_b
quit
