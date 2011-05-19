load unbound_3d1g_ab.pdb
load peptide_3d1e_p.pdb
color white, unbound_3d1g_ab
color red, peptide_3d1e_p
show_as cartoon, all
orient
show sticks, peptide_3d1e_p
create unbound_3d1g_ab.surface, unbound_3d1g_ab; color white, unbound_3d1g_ab.surface; set transparency, 0.6, unbound_3d1g_ab.surface; show_as surface, unbound_3d1g_ab.surface; disable unbound_3d1g_ab.surface
load unbound_3d1g_ab_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_3d1g_ab_out/pockets/pocket10_vert.pqr, pocket10_vert.pqr
load unbound_3d1g_ab_out/pockets/pocket11_vert.pqr, pocket11_vert.pqr
load unbound_3d1g_ab_out/pockets/pocket12_vert.pqr, pocket12_vert.pqr
load unbound_3d1g_ab_out/pockets/pocket13_vert.pqr, pocket13_vert.pqr
load unbound_3d1g_ab_out/pockets/pocket14_vert.pqr, pocket14_vert.pqr
load unbound_3d1g_ab_out/pockets/pocket15_vert.pqr, pocket15_vert.pqr
load unbound_3d1g_ab_out/pockets/pocket16_vert.pqr, pocket16_vert.pqr
load unbound_3d1g_ab_out/pockets/pocket17_vert.pqr, pocket17_vert.pqr
load unbound_3d1g_ab_out/pockets/pocket18_vert.pqr, pocket18_vert.pqr
load unbound_3d1g_ab_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
load unbound_3d1g_ab_out/pockets/pocket2_vert.pqr, pocket2_vert.pqr
load unbound_3d1g_ab_out/pockets/pocket3_vert.pqr, pocket3_vert.pqr
load unbound_3d1g_ab_out/pockets/pocket4_vert.pqr, pocket4_vert.pqr
load unbound_3d1g_ab_out/pockets/pocket5_vert.pqr, pocket5_vert.pqr
load unbound_3d1g_ab_out/pockets/pocket6_vert.pqr, pocket6_vert.pqr
load unbound_3d1g_ab_out/pockets/pocket7_vert.pqr, pocket7_vert.pqr
load unbound_3d1g_ab_out/pockets/pocket8_vert.pqr, pocket8_vert.pqr
load unbound_3d1g_ab_out/pockets/pocket9_vert.pqr, pocket9_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_3d1e_p
