load 1jd5.pdb, 1jd5_bound
select bound_1jd5_a, polymer and 1jd5_bound and chain a
select peptide_1jd5_b, polymer and 1jd5_bound and chain b
load 1jd4.pdb, 1jd4_unbound
select unbound_1jd4_a, polymer and 1jd4_unbound and chain a
align polymer and name ca and bound_1jd5_a, polymer and name ca and unbound_1jd4_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1jd4_a.pdb, unbound_1jd4_a
save bound_1jd5_a.pdb, bound_1jd5_a
save peptide_1jd5_b.pdb, peptide_1jd5_b
quit
