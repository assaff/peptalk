load /vol/ek/share/pdb/ss/pdb1ssh.ent.gz, 1ssh_bound
select bound_1ssh_a, polymer and 1ssh_bound and chain a
load /vol/ek/share/pdb/oo/pdb1oot.ent.gz, 1oot_unbound
select unbound_1oot_a, polymer and 1oot_unbound and chain a
align polymer and name ca and bound_1ssh_a, polymer and name ca and unbound_1oot_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1ssh_b, polymer and 1ssh_bound and chain b
deselect
color lime, 1ssh_bound
color forest, bound_1ssh_a
color cyan, 1oot_unbound
color blue, unbound_1oot_a
color red, peptide_1ssh_b
show_as cartoon, all
orient
show sticks, sc. and peptide_1ssh_b
symexp unbound_sym, 1oot_unbound, (1oot_unbound), 5.0
symexp bound_sym, 1ssh_bound, (1ssh_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1ssh, 1ssh_bound and not polymer and not resn HOH
select ligands_1oot, 1oot_unbound and not polymer and not resn HOH
show_as spheres, ligands_1ssh or ligands_1oot
