load 1lvm.pdb, 1lvm_bound
select bound_1lvm_ac, polymer and 1lvm_bound and chain a+c
select peptide_1lvm_e, polymer and 1lvm_bound and chain e
load 1lvb.pdb, 1lvb_unbound
select unbound_1lvb_ac, polymer and 1lvb_unbound and chain a+c
align polymer and name ca and bound_1lvm_ac, polymer and name ca and unbound_1lvb_ac, quiet=0, object="aln_bound_unbound", reset=1
deselect
save unbound_1lvb_ac.pdb, unbound_1lvb_ac
save bound_1lvm_ac.pdb, bound_1lvm_ac
save peptide_1lvm_e.pdb, peptide_1lvm_e
quit
