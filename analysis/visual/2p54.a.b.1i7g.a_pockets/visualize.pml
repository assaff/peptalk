load unbound_1i7g_a.pdb
load peptide_2p54_b.pdb
color white, unbound_1i7g_a
color red, peptide_2p54_b
show_as cartoon, all
orient
show sticks, peptide_2p54_b
create unbound_1i7g_a.surface, unbound_1i7g_a; color white, unbound_1i7g_a.surface; set transparency, 0.6, unbound_1i7g_a.surface; show_as surface, unbound_1i7g_a.surface; disable unbound_1i7g_a.surface
load unbound_1i7g_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_1i7g_a_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
load unbound_1i7g_a_out/pockets/pocket2_vert.pqr, pocket2_vert.pqr
load unbound_1i7g_a_out/pockets/pocket3_vert.pqr, pocket3_vert.pqr
load unbound_1i7g_a_out/pockets/pocket4_vert.pqr, pocket4_vert.pqr
load unbound_1i7g_a_out/pockets/pocket5_vert.pqr, pocket5_vert.pqr
load unbound_1i7g_a_out/pockets/pocket6_vert.pqr, pocket6_vert.pqr
load unbound_1i7g_a_out/pockets/pocket7_vert.pqr, pocket7_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_2p54_b
