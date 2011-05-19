load 2j6f.pdb, 2j6f_bound
select bound_2j6f_a, polymer and 2j6f_bound and chain a
select peptide_2j6f_c, polymer and 2j6f_bound and chain c
load 2da9.pdb, 2da9_unbound
select unbound_2da9_a, polymer and 2da9_unbound and chain a
align polymer and name ca and bound_2j6f_a, polymer and name ca and unbound_2da9_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2da9_a.pdb, unbound_2da9_a
save bound_2j6f_a.pdb, bound_2j6f_a
save peptide_2j6f_c.pdb, peptide_2j6f_c
quit
