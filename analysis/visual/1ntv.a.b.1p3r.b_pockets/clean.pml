load 1ntv.pdb, 1ntv_bound
select bound_1ntv_a, polymer and 1ntv_bound and chain a
select peptide_1ntv_b, polymer and 1ntv_bound and chain b
load 1p3r.pdb, 1p3r_unbound
select unbound_1p3r_b, polymer and 1p3r_unbound and chain b
align polymer and name ca and bound_1ntv_a, polymer and name ca and unbound_1p3r_b, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1p3r_b.pdb, unbound_1p3r_b
save bound_1ntv_a.pdb, bound_1ntv_a
save peptide_1ntv_b.pdb, peptide_1ntv_b
quit
