load unbound_2idh_a.pdb
load peptide_2ho2_b.pdb
color white, unbound_2idh_a
color red, peptide_2ho2_b
show_as cartoon, all
orient
show sticks, peptide_2ho2_b
create unbound_2idh_a.surface, unbound_2idh_a; color white, unbound_2idh_a.surface; set transparency, 0.6, unbound_2idh_a.surface; show_as surface, unbound_2idh_a.surface; disable unbound_2idh_a.surface
load unbound_2idh_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_2ho2_b
