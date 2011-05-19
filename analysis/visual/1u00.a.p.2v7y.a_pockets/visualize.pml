load unbound_2v7y_a.pdb
load peptide_1u00_p.pdb
color white, unbound_2v7y_a
color red, peptide_1u00_p
show_as cartoon, all
orient
show sticks, peptide_1u00_p
create unbound_2v7y_a.surface, unbound_2v7y_a; color white, unbound_2v7y_a.surface; set transparency, 0.6, unbound_2v7y_a.surface; show_as surface, unbound_2v7y_a.surface; disable unbound_2v7y_a.surface
load unbound_2v7y_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_2v7y_a_out/pockets/pocket10_vert.pqr, pocket10_vert.pqr
load unbound_2v7y_a_out/pockets/pocket11_vert.pqr, pocket11_vert.pqr
load unbound_2v7y_a_out/pockets/pocket12_vert.pqr, pocket12_vert.pqr
load unbound_2v7y_a_out/pockets/pocket13_vert.pqr, pocket13_vert.pqr
load unbound_2v7y_a_out/pockets/pocket14_vert.pqr, pocket14_vert.pqr
load unbound_2v7y_a_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
load unbound_2v7y_a_out/pockets/pocket2_vert.pqr, pocket2_vert.pqr
load unbound_2v7y_a_out/pockets/pocket3_vert.pqr, pocket3_vert.pqr
load unbound_2v7y_a_out/pockets/pocket4_vert.pqr, pocket4_vert.pqr
load unbound_2v7y_a_out/pockets/pocket5_vert.pqr, pocket5_vert.pqr
load unbound_2v7y_a_out/pockets/pocket6_vert.pqr, pocket6_vert.pqr
load unbound_2v7y_a_out/pockets/pocket7_vert.pqr, pocket7_vert.pqr
load unbound_2v7y_a_out/pockets/pocket8_vert.pqr, pocket8_vert.pqr
load unbound_2v7y_a_out/pockets/pocket9_vert.pqr, pocket9_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_1u00_p
