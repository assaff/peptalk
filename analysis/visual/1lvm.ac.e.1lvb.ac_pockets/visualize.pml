load unbound_1lvb_ac.pdb
load peptide_1lvm_e.pdb
color white, unbound_1lvb_ac
color red, peptide_1lvm_e
show_as cartoon, all
orient
show sticks, peptide_1lvm_e
create unbound_1lvb_ac.surface, unbound_1lvb_ac; color white, unbound_1lvb_ac.surface; set transparency, 0.6, unbound_1lvb_ac.surface; show_as surface, unbound_1lvb_ac.surface; disable unbound_1lvb_ac.surface
load unbound_1lvb_ac_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_1lvb_ac_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
load unbound_1lvb_ac_out/pockets/pocket2_vert.pqr, pocket2_vert.pqr
load unbound_1lvb_ac_out/pockets/pocket3_vert.pqr, pocket3_vert.pqr
load unbound_1lvb_ac_out/pockets/pocket4_vert.pqr, pocket4_vert.pqr
load unbound_1lvb_ac_out/pockets/pocket5_vert.pqr, pocket5_vert.pqr
load unbound_1lvb_ac_out/pockets/pocket6_vert.pqr, pocket6_vert.pqr
load unbound_1lvb_ac_out/pockets/pocket7_vert.pqr, pocket7_vert.pqr
load unbound_1lvb_ac_out/pockets/pocket8_vert.pqr, pocket8_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_1lvm_e
