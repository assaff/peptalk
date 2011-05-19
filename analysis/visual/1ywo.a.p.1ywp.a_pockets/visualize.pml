load unbound_1ywp_a.pdb
load peptide_1ywo_p.pdb
color white, unbound_1ywp_a
color red, peptide_1ywo_p
show_as cartoon, all
orient
show sticks, peptide_1ywo_p
create unbound_1ywp_a.surface, unbound_1ywp_a; color white, unbound_1ywp_a.surface; set transparency, 0.6, unbound_1ywp_a.surface; show_as surface, unbound_1ywp_a.surface; disable unbound_1ywp_a.surface
load unbound_1ywp_a_out/pockets/pocket*vert.pqr, pocket*vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_1ywo_p
