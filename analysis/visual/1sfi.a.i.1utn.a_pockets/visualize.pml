load unbound_1utn_a.pdb
load peptide_1sfi_i.pdb
color white, unbound_1utn_a
color red, peptide_1sfi_i
show_as cartoon, all
orient
show sticks, peptide_1sfi_i
create unbound_1utn_a.surface, unbound_1utn_a; color white, unbound_1utn_a.surface; set transparency, 0.6, unbound_1utn_a.surface; show_as surface, unbound_1utn_a.surface; disable unbound_1utn_a.surface
load unbound_1utn_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_1utn_a_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
load unbound_1utn_a_out/pockets/pocket2_vert.pqr, pocket2_vert.pqr
load unbound_1utn_a_out/pockets/pocket3_vert.pqr, pocket3_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_1sfi_i
