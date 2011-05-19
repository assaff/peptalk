load unbound_1n7e_a.pdb
load peptide_1n7f_d.pdb
color white, unbound_1n7e_a
color red, peptide_1n7f_d
show_as cartoon, all
orient
show sticks, peptide_1n7f_d
create unbound_1n7e_a.surface, unbound_1n7e_a; color white, unbound_1n7e_a.surface; set transparency, 0.6, unbound_1n7e_a.surface; show_as surface, unbound_1n7e_a.surface; disable unbound_1n7e_a.surface
load unbound_1n7e_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_1n7e_a_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
load unbound_1n7e_a_out/pockets/pocket2_vert.pqr, pocket2_vert.pqr
load unbound_1n7e_a_out/pockets/pocket3_vert.pqr, pocket3_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_1n7f_d
