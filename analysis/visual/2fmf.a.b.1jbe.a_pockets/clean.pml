load 2fmf.pdb, 2fmf_bound
select bound_2fmf_a, polymer and 2fmf_bound and chain a
select peptide_2fmf_b, polymer and 2fmf_bound and chain b
load 1jbe.pdb, 1jbe_unbound
select unbound_1jbe_a, polymer and 1jbe_unbound and chain a
align polymer and name ca and bound_2fmf_a, polymer and name ca and unbound_1jbe_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1jbe_a.pdb, unbound_1jbe_a
save bound_2fmf_a.pdb, bound_2fmf_a
save peptide_2fmf_b.pdb, peptide_2fmf_b
quit
