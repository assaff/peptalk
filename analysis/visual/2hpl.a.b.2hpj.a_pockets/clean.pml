load 2hpl.pdb, 2hpl_bound
select bound_2hpl_a, polymer and 2hpl_bound and chain a
select peptide_2hpl_b, polymer and 2hpl_bound and chain b
load 2hpj.pdb, 2hpj_unbound
select unbound_2hpj_a, polymer and 2hpj_unbound and chain a
align polymer and name ca and bound_2hpl_a, polymer and name ca and unbound_2hpj_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2hpj_a.pdb, unbound_2hpj_a
save bound_2hpl_a.pdb, bound_2hpl_a
save peptide_2hpl_b.pdb, peptide_2hpl_b
quit
