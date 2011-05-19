load 1nx1.pdb, 1nx1_bound
select bound_1nx1_ab, polymer and 1nx1_bound and chain a+b
select peptide_1nx1_cd, polymer and 1nx1_bound and chain c+d
load 1alv.pdb, 1alv_unbound
select unbound_1alv_ab, polymer and 1alv_unbound and chain a+b
align polymer and name ca and bound_1nx1_ab, polymer and name ca and unbound_1alv_ab, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1alv_ab.pdb, unbound_1alv_ab
save bound_1nx1_ab.pdb, bound_1nx1_ab
save peptide_1nx1_cd.pdb, peptide_1nx1_cd
quit
