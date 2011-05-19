load unbound_2am9_a.pdb
load peptide_1t7r_b.pdb
color white, unbound_2am9_a
color red, peptide_1t7r_b
show_as cartoon, all
orient
show sticks, peptide_1t7r_b
create unbound_2am9_a.surface, unbound_2am9_a; color white, unbound_2am9_a.surface; set transparency, 0.6, unbound_2am9_a.surface; show_as surface, unbound_2am9_a.surface; disable unbound_2am9_a.surface
load unbound_2am9_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_2am9_a_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
load unbound_2am9_a_out/pockets/pocket2_vert.pqr, pocket2_vert.pqr
load unbound_2am9_a_out/pockets/pocket3_vert.pqr, pocket3_vert.pqr
load unbound_2am9_a_out/pockets/pocket4_vert.pqr, pocket4_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_1t7r_b
