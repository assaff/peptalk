load unbound_1c9q_a.pdb
load peptide_1se0_b.pdb
color white, unbound_1c9q_a
color red, peptide_1se0_b
show_as cartoon, all
orient
show sticks, peptide_1se0_b
create unbound_1c9q_a.surface, unbound_1c9q_a; color white, unbound_1c9q_a.surface; set transparency, 0.6, unbound_1c9q_a.surface; show_as surface, unbound_1c9q_a.surface; disable unbound_1c9q_a.surface
load unbound_1c9q_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_1c9q_a_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
load unbound_1c9q_a_out/pockets/pocket2_vert.pqr, pocket2_vert.pqr
load unbound_1c9q_a_out/pockets/pocket3_vert.pqr, pocket3_vert.pqr
load unbound_1c9q_a_out/pockets/pocket4_vert.pqr, pocket4_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_1se0_b
