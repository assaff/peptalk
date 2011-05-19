load unbound_2qg1_a.pdb
load peptide_1ihj_d.pdb
color white, unbound_2qg1_a
color red, peptide_1ihj_d
show_as cartoon, all
orient
show sticks, peptide_1ihj_d
create unbound_2qg1_a.surface, unbound_2qg1_a; color white, unbound_2qg1_a.surface; set transparency, 0.6, unbound_2qg1_a.surface; show_as surface, unbound_2qg1_a.surface; disable unbound_2qg1_a.surface
load unbound_2qg1_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_2qg1_a_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_1ihj_d
