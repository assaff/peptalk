load /vol/ek/share/pdb/oa/pdb1oai.ent.gz, 1oai_bound
select bound_1oai_a, polymer and 1oai_bound and chain a
load /vol/ek/share/pdb/go/pdb1go5.ent.gz, 1go5_unbound
select unbound_1go5_a, polymer and 1go5_unbound and chain a
align polymer and name ca and bound_1oai_a, polymer and name ca and unbound_1go5_a, quiet=0, object="aln_bound_unbound", reset=1
select peptide_1oai_b, polymer and 1oai_bound and chain b
deselect
color lime, 1oai_bound
color forest, bound_1oai_a
color cyan, 1go5_unbound
color blue, unbound_1go5_a
color red, peptide_1oai_b
show_as cartoon, all
orient
show sticks, sc. and peptide_1oai_b
symexp unbound_sym, 1go5_unbound, (1go5_unbound), 5.0
symexp bound_sym, 1oai_bound, (1oai_bound), 5.0
show_as cartoon, *_sym*; color white, *_sym*; disable *_sym*
select ligands_1oai, 1oai_bound and not polymer and not resn HOH
select ligands_1go5, 1go5_unbound and not polymer and not resn HOH
show_as spheres, ligands_1oai or ligands_1go5
