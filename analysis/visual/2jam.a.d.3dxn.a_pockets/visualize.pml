load unbound_3dxn_a.pdb
load peptide_2jam_d.pdb
color white, unbound_3dxn_a
color red, peptide_2jam_d
show_as cartoon, all
orient
show sticks, peptide_2jam_d
create unbound_3dxn_a.surface, unbound_3dxn_a; color white, unbound_3dxn_a.surface; set transparency, 0.6, unbound_3dxn_a.surface; show_as surface, unbound_3dxn_a.surface; disable unbound_3dxn_a.surface
load unbound_3dxn_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_3dxn_a_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
load unbound_3dxn_a_out/pockets/pocket2_vert.pqr, pocket2_vert.pqr
load unbound_3dxn_a_out/pockets/pocket3_vert.pqr, pocket3_vert.pqr
load unbound_3dxn_a_out/pockets/pocket4_vert.pqr, pocket4_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_2jam_d
