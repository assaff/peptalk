load unbound_1hil_b.pdb
load peptide_1qkz_p.pdb
color white, unbound_1hil_b
color red, peptide_1qkz_p
show_as cartoon, all
orient
show sticks, peptide_1qkz_p
create unbound_1hil_b.surface, unbound_1hil_b; color white, unbound_1hil_b.surface; set transparency, 0.6, unbound_1hil_b.surface; show_as surface, unbound_1hil_b.surface; disable unbound_1hil_b.surface
load unbound_1hil_b_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_1hil_b_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
load unbound_1hil_b_out/pockets/pocket2_vert.pqr, pocket2_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_1qkz_p
