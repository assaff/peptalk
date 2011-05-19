load unbound_1oot_a.pdb
load peptide_1ssh_b.pdb
color white, unbound_1oot_a
color red, peptide_1ssh_b
show_as cartoon, all
orient
show sticks, peptide_1ssh_b
create unbound_1oot_a.surface, unbound_1oot_a; color white, unbound_1oot_a.surface; set transparency, 0.6, unbound_1oot_a.surface; show_as surface, unbound_1oot_a.surface; disable unbound_1oot_a.surface
load unbound_1oot_a_out/pockets/pocket*vert.pqr, pocket*vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_1ssh_b
