load 3d1e.pdb, 3d1e_bound
select bound_3d1e_ab, polymer and 3d1e_bound and chain a+b
select peptide_3d1e_p, polymer and 3d1e_bound and chain p
load 3d1g.pdb, 3d1g_unbound
select unbound_3d1g_ab, polymer and 3d1g_unbound and chain a+b
align polymer and name ca and bound_3d1e_ab, polymer and name ca and unbound_3d1g_ab, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_3d1g_ab.pdb, unbound_3d1g_ab
save bound_3d1e_ab.pdb, bound_3d1e_ab
save peptide_3d1e_p.pdb, peptide_3d1e_p
quit
