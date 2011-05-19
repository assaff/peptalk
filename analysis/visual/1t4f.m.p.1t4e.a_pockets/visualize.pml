load unbound_1t4e_a.pdb
load peptide_1t4f_p.pdb
color white, unbound_1t4e_a
color red, peptide_1t4f_p
show_as cartoon, all
orient
show sticks, peptide_1t4f_p
create unbound_1t4e_a.surface, unbound_1t4e_a; color white, unbound_1t4e_a.surface; set transparency, 0.6, unbound_1t4e_a.surface; show_as surface, unbound_1t4e_a.surface; disable unbound_1t4e_a.surface
load unbound_1t4e_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_1t4e_a_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
load unbound_1t4e_a_out/pockets/pocket2_vert.pqr, pocket2_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_1t4f_p
