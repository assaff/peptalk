load unbound_3d6d_a.pdb
load peptide_1fm9_e.pdb
color white, unbound_3d6d_a
color red, peptide_1fm9_e
show_as cartoon, all
orient
show sticks, peptide_1fm9_e
create unbound_3d6d_a.surface, unbound_3d6d_a; color white, unbound_3d6d_a.surface; set transparency, 0.6, unbound_3d6d_a.surface; show_as surface, unbound_3d6d_a.surface; disable unbound_3d6d_a.surface
load unbound_3d6d_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_3d6d_a_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
load unbound_3d6d_a_out/pockets/pocket2_vert.pqr, pocket2_vert.pqr
load unbound_3d6d_a_out/pockets/pocket3_vert.pqr, pocket3_vert.pqr
load unbound_3d6d_a_out/pockets/pocket4_vert.pqr, pocket4_vert.pqr
load unbound_3d6d_a_out/pockets/pocket5_vert.pqr, pocket5_vert.pqr
load unbound_3d6d_a_out/pockets/pocket6_vert.pqr, pocket6_vert.pqr
load unbound_3d6d_a_out/pockets/pocket7_vert.pqr, pocket7_vert.pqr
load unbound_3d6d_a_out/pockets/pocket8_vert.pqr, pocket8_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_1fm9_e
