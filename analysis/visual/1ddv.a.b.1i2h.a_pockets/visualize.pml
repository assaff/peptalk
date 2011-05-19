load unbound_1i2h_a.pdb
load peptide_1ddv_b.pdb
color white, unbound_1i2h_a
color red, peptide_1ddv_b
show_as cartoon, all
orient
show sticks, peptide_1ddv_b
create unbound_1i2h_a.surface, unbound_1i2h_a; color white, unbound_1i2h_a.surface; set transparency, 0.6, unbound_1i2h_a.surface; show_as surface, unbound_1i2h_a.surface; disable unbound_1i2h_a.surface
load unbound_1i2h_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_1i2h_a_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
load unbound_1i2h_a_out/pockets/pocket2_vert.pqr, pocket2_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_1ddv_b
