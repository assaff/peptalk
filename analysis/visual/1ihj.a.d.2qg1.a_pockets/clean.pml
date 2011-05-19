load 1ihj.pdb, 1ihj_bound
select bound_1ihj_a, polymer and 1ihj_bound and chain a
select peptide_1ihj_d, polymer and 1ihj_bound and chain d
load 2qg1.pdb, 2qg1_unbound
select unbound_2qg1_a, polymer and 2qg1_unbound and chain a
align polymer and name ca and bound_1ihj_a, polymer and name ca and unbound_2qg1_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_2qg1_a.pdb, unbound_2qg1_a
save bound_1ihj_a.pdb, bound_1ihj_a
save peptide_1ihj_d.pdb, peptide_1ihj_d
quit
