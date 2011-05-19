load unbound_1r6j_a.pdb
load peptide_1w9e_t.pdb
color white, unbound_1r6j_a
color red, peptide_1w9e_t
show_as cartoon, all
orient
show sticks, peptide_1w9e_t
create unbound_1r6j_a.surface, unbound_1r6j_a; color white, unbound_1r6j_a.surface; set transparency, 0.6, unbound_1r6j_a.surface; show_as surface, unbound_1r6j_a.surface; disable unbound_1r6j_a.surface
load unbound_1r6j_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_1w9e_t
