load 2df6.pdb, 2df6_bound
select bound_2df6_b, polymer and 2df6_bound and chain b
select peptide_2df6_d, polymer and 2df6_bound and chain d
load 2g6f.pdb, 2g6f_unbound
select unbound_2g6f_x, polymer and 2g6f_unbound and chain x
align polymer and name ca and bound_2df6_b, polymer and name ca and unbound_2g6f_x, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2g6f_x.pdb, unbound_2g6f_x
save bound_2df6_b.pdb, bound_2df6_b
save peptide_2df6_d.pdb, peptide_2df6_d
quit
