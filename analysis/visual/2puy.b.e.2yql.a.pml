load /vol/ek/share/pdb/pu/pdb2puy.ent.gz, 2puy_bound
select bound_2puy_b, polymer and 2puy_bound and chain b
load /vol/ek/share/pdb/yq/pdb2yql.ent.gz, 2yql_unbound
select unbound_2yql_a, polymer and 2yql_unbound and chain a
align polymer and name ca and bound_2puy_b, polymer and name ca and unbound_2yql_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_2puy_e, polymer and 2puy_bound and chain e
deselect
color lime, 2puy_bound
color forest, bound_2puy_b
color cyan, 2yql_unbound
color blue, unbound_2yql_a
color red, peptide_2puy_e
show_as cartoon, all
orient
show sticks, sc. and peptide_2puy_e
symexp unbound_sym, 2yql_unbound, (2yql_unbound), 5.0
symexp bound_sym, 2puy_bound, (2puy_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_2puy, 2puy_bound and not polymer and not resn HOH
select ligands_2yql, 2yql_unbound and not polymer and not resn HOH
show_as spheres, ligands_2puy or ligands_2yql
