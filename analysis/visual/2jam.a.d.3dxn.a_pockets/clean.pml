load 2jam.pdb, 2jam_bound
select bound_2jam_a, polymer and 2jam_bound and chain a
select peptide_2jam_d, polymer and 2jam_bound and chain d
load 3dxn.pdb, 3dxn_unbound
select unbound_3dxn_a, polymer and 3dxn_unbound and chain a
align polymer and name ca and bound_2jam_a, polymer and name ca and unbound_3dxn_a, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_3dxn_a.pdb, unbound_3dxn_a
save bound_2jam_a.pdb, bound_2jam_a
save peptide_2jam_d.pdb, peptide_2jam_d
quit
