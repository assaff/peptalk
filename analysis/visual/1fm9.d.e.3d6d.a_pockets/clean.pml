load 1fm9.pdb, 1fm9_bound
select bound_1fm9_d, polymer and 1fm9_bound and chain d
select peptide_1fm9_e, polymer and 1fm9_bound and chain e
load 3d6d.pdb, 3d6d_unbound
select unbound_3d6d_a, polymer and 3d6d_unbound and chain a
align polymer and name ca and bound_1fm9_d, polymer and name ca and unbound_3d6d_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_3d6d_a.pdb, unbound_3d6d_a
save bound_1fm9_d.pdb, bound_1fm9_d
save peptide_1fm9_e.pdb, peptide_1fm9_e
quit
