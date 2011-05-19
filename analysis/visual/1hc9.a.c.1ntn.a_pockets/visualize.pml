load unbound_1ntn_a.pdb
load peptide_1hc9_c.pdb
color white, unbound_1ntn_a
color red, peptide_1hc9_c
show_as cartoon, all
orient
show sticks, peptide_1hc9_c
create unbound_1ntn_a.surface, unbound_1ntn_a; color white, unbound_1ntn_a.surface; set transparency, 0.6, unbound_1ntn_a.surface; show_as surface, unbound_1ntn_a.surface; disable unbound_1ntn_a.surface
load unbound_1ntn_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_1hc9_c
