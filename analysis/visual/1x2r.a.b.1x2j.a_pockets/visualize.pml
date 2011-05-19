load unbound_1x2j_a.pdb
load peptide_1x2r_b.pdb
color white, unbound_1x2j_a
color red, peptide_1x2r_b
show_as cartoon, all
orient
show sticks, peptide_1x2r_b
create unbound_1x2j_a.surface, unbound_1x2j_a; color white, unbound_1x2j_a.surface; set transparency, 0.6, unbound_1x2j_a.surface; show_as surface, unbound_1x2j_a.surface; disable unbound_1x2j_a.surface
load unbound_1x2j_a_out/pockets/pocket*vert.pqr, pocket*vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_1x2r_b
