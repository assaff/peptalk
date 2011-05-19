load unbound_1h1r_ab.pdb
load peptide_2cch_e.pdb
color white, unbound_1h1r_ab
color red, peptide_2cch_e
show_as cartoon, all
orient
show sticks, peptide_2cch_e
create unbound_1h1r_ab.surface, unbound_1h1r_ab; color white, unbound_1h1r_ab.surface; set transparency, 0.6, unbound_1h1r_ab.surface; show_as surface, unbound_1h1r_ab.surface; disable unbound_1h1r_ab.surface
load unbound_1h1r_ab_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_1h1r_ab_out/pockets/pocket10_vert.pqr, pocket10_vert.pqr
load unbound_1h1r_ab_out/pockets/pocket11_vert.pqr, pocket11_vert.pqr
load unbound_1h1r_ab_out/pockets/pocket12_vert.pqr, pocket12_vert.pqr
load unbound_1h1r_ab_out/pockets/pocket13_vert.pqr, pocket13_vert.pqr
load unbound_1h1r_ab_out/pockets/pocket14_vert.pqr, pocket14_vert.pqr
load unbound_1h1r_ab_out/pockets/pocket15_vert.pqr, pocket15_vert.pqr
load unbound_1h1r_ab_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
load unbound_1h1r_ab_out/pockets/pocket2_vert.pqr, pocket2_vert.pqr
load unbound_1h1r_ab_out/pockets/pocket3_vert.pqr, pocket3_vert.pqr
load unbound_1h1r_ab_out/pockets/pocket4_vert.pqr, pocket4_vert.pqr
load unbound_1h1r_ab_out/pockets/pocket5_vert.pqr, pocket5_vert.pqr
load unbound_1h1r_ab_out/pockets/pocket6_vert.pqr, pocket6_vert.pqr
load unbound_1h1r_ab_out/pockets/pocket7_vert.pqr, pocket7_vert.pqr
load unbound_1h1r_ab_out/pockets/pocket8_vert.pqr, pocket8_vert.pqr
load unbound_1h1r_ab_out/pockets/pocket9_vert.pqr, pocket9_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_2cch_e
