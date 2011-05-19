load unbound_1go5_a.pdb
load peptide_1oai_b.pdb
color white, unbound_1go5_a
color red, peptide_1oai_b
show_as cartoon, all
orient
show sticks, peptide_1oai_b
create unbound_1go5_a.surface, unbound_1go5_a; color white, unbound_1go5_a.surface; set transparency, 0.6, unbound_1go5_a.surface; show_as surface, unbound_1go5_a.surface; disable unbound_1go5_a.surface
load unbound_1go5_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_1go5_a_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_1oai_b
