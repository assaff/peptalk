load unbound_1rwz_a.pdb
load peptide_1rxz_b.pdb
color white, unbound_1rwz_a
color red, peptide_1rxz_b
show_as cartoon, all
orient
show sticks, peptide_1rxz_b
create unbound_1rwz_a.surface, unbound_1rwz_a; color white, unbound_1rwz_a.surface; set transparency, 0.6, unbound_1rwz_a.surface; show_as surface, unbound_1rwz_a.surface; disable unbound_1rwz_a.surface
load unbound_1rwz_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_1rwz_a_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
load unbound_1rwz_a_out/pockets/pocket2_vert.pqr, pocket2_vert.pqr
load unbound_1rwz_a_out/pockets/pocket3_vert.pqr, pocket3_vert.pqr
load unbound_1rwz_a_out/pockets/pocket4_vert.pqr, pocket4_vert.pqr
load unbound_1rwz_a_out/pockets/pocket5_vert.pqr, pocket5_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_1rxz_b
