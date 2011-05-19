load unbound_2f1w_a.pdb
load peptide_2foj_b.pdb
color white, unbound_2f1w_a
color red, peptide_2foj_b
show_as cartoon, all
orient
show sticks, peptide_2foj_b
create unbound_2f1w_a.surface, unbound_2f1w_a; color white, unbound_2f1w_a.surface; set transparency, 0.6, unbound_2f1w_a.surface; show_as surface, unbound_2f1w_a.surface; disable unbound_2f1w_a.surface
load unbound_2f1w_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_2f1w_a_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_2foj_b
