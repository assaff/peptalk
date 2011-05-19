load unbound_1eg3_a.pdb
load peptide_1eg4_p.pdb
color white, unbound_1eg3_a
color red, peptide_1eg4_p
show_as cartoon, all
orient
show sticks, peptide_1eg4_p
create unbound_1eg3_a.surface, unbound_1eg3_a; color white, unbound_1eg3_a.surface; set transparency, 0.6, unbound_1eg3_a.surface; show_as surface, unbound_1eg3_a.surface; disable unbound_1eg3_a.surface
load unbound_1eg3_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_1eg3_a_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
load unbound_1eg3_a_out/pockets/pocket2_vert.pqr, pocket2_vert.pqr
load unbound_1eg3_a_out/pockets/pocket3_vert.pqr, pocket3_vert.pqr
load unbound_1eg3_a_out/pockets/pocket4_vert.pqr, pocket4_vert.pqr
load unbound_1eg3_a_out/pockets/pocket5_vert.pqr, pocket5_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_1eg4_p
