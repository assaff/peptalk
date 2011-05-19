load 1gyb.pdb, 1gyb_bound
select bound_1gyb_ab, polymer and 1gyb_bound and chain a+b
select peptide_1gyb_ef, polymer and 1gyb_bound and chain e+f
load 1gy7.pdb, 1gy7_unbound
select unbound_1gy7_ab, polymer and 1gy7_unbound and chain a+b
align polymer and name ca and bound_1gyb_ab, polymer and name ca and unbound_1gy7_ab, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1gy7_ab.pdb, unbound_1gy7_ab
save bound_1gyb_ab.pdb, bound_1gyb_ab
save peptide_1gyb_ef.pdb, peptide_1gyb_ef
quit
