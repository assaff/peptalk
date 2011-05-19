load /vol/ek/share/pdb/ja/pdb2jam.ent.gz, 2jam_bound
select bound_2jam_a, polymer and 2jam_bound and chain a
load /vol/ek/share/pdb/dx/pdb3dxn.ent.gz, 3dxn_unbound
select unbound_3dxn_a, polymer and 3dxn_unbound and chain a
align polymer and name ca and bound_2jam_a, polymer and name ca and unbound_3dxn_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_2jam_d, polymer and 2jam_bound and chain d
deselect
color lime, 2jam_bound
color forest, bound_2jam_a
color cyan, 3dxn_unbound
color blue, unbound_3dxn_a
color red, peptide_2jam_d
show_as cartoon, all
orient
show sticks, sc. and peptide_2jam_d
symexp unbound_sym, 3dxn_unbound, (3dxn_unbound), 5.0
symexp bound_sym, 2jam_bound, (2jam_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_2jam, 2jam_bound and not polymer and not resn HOH
select ligands_3dxn, 3dxn_unbound and not polymer and not resn HOH
show_as spheres, ligands_2jam or ligands_3dxn
