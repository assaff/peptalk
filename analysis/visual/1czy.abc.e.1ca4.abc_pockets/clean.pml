load 1czy.pdb, 1czy_bound
select bound_1czy_abc, polymer and 1czy_bound and chain a+b+c
select peptide_1czy_e, polymer and 1czy_bound and chain e
load 1ca4.pdb, 1ca4_unbound
select unbound_1ca4_abc, polymer and 1ca4_unbound and chain a+b+c
align polymer and name ca and bound_1czy_abc, polymer and name ca and unbound_1ca4_abc, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1ca4_abc.pdb, unbound_1ca4_abc
save bound_1czy_abc.pdb, bound_1czy_abc
save peptide_1czy_e.pdb, peptide_1czy_e
quit
