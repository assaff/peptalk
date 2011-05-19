load 2cch.pdb, 2cch_bound
select bound_2cch_ab, polymer and 2cch_bound and chain a+b
select peptide_2cch_e, polymer and 2cch_bound and chain e
load 1h1r.pdb, 1h1r_unbound
select unbound_1h1r_ab, polymer and 1h1r_unbound and chain a+b
align polymer and name ca and bound_2cch_ab, polymer and name ca and unbound_1h1r_ab, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1h1r_ab.pdb, unbound_1h1r_ab
save bound_2cch_ab.pdb, bound_2cch_ab
save peptide_2cch_e.pdb, peptide_2cch_e
quit
