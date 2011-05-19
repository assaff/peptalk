load /vol/ek/share/pdb/lv/pdb1lvm.ent.gz, 1lvm_bound
select bound_1lvm_ac, polymer and 1lvm_bound and chain a+c
load /vol/ek/share/pdb/lv/pdb1lvb.ent.gz, 1lvb_unbound
select unbound_1lvb_ac, polymer and 1lvb_unbound and chain a+c
align polymer and name ca and bound_1lvm_ac, polymer and name ca and unbound_1lvb_ac, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1lvm_e, polymer and 1lvm_bound and chain e
deselect
color lime, 1lvm_bound
color forest, bound_1lvm_ac
color cyan, 1lvb_unbound
color blue, unbound_1lvb_ac
color red, peptide_1lvm_e
show_as cartoon, all
orient
show sticks, sc. and peptide_1lvm_e
symexp unbound_sym, 1lvb_unbound, (1lvb_unbound), 5.0
symexp bound_sym, 1lvm_bound, (1lvm_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1lvm, 1lvm_bound and not polymer and not resn HOH
select ligands_1lvb, 1lvb_unbound and not polymer and not resn HOH
show_as spheres, ligands_1lvm or ligands_1lvb
