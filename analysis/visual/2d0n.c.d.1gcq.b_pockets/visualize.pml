load unbound_1gcq_b.pdb
load peptide_2d0n_d.pdb
color white, unbound_1gcq_b
color red, peptide_2d0n_d
show_as cartoon, all
orient
show sticks, peptide_2d0n_d
create unbound_1gcq_b.surface, unbound_1gcq_b; color white, unbound_1gcq_b.surface; set transparency, 0.6, unbound_1gcq_b.surface; show_as surface, unbound_1gcq_b.surface; disable unbound_1gcq_b.surface
load unbound_1gcq_b_out/pockets/pocket*vert.pqr, pocket*vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_2d0n_d
