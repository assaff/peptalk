load unbound_1p3r_b.pdb
load peptide_1ntv_b.pdb
color white, unbound_1p3r_b
color red, peptide_1ntv_b
show_as cartoon, all
orient
show sticks, peptide_1ntv_b
create unbound_1p3r_b.surface, unbound_1p3r_b; color white, unbound_1p3r_b.surface; set transparency, 0.6, unbound_1p3r_b.surface; show_as surface, unbound_1p3r_b.surface; disable unbound_1p3r_b.surface
load unbound_1p3r_b_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_1p3r_b_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
load unbound_1p3r_b_out/pockets/pocket2_vert.pqr, pocket2_vert.pqr
load unbound_1p3r_b_out/pockets/pocket3_vert.pqr, pocket3_vert.pqr
load unbound_1p3r_b_out/pockets/pocket4_vert.pqr, pocket4_vert.pqr
load unbound_1p3r_b_out/pockets/pocket5_vert.pqr, pocket5_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_1ntv_b
