load unbound_1jd4_a.pdb
load peptide_1jd5_b.pdb
color white, unbound_1jd4_a
color red, peptide_1jd5_b
show_as cartoon, all
orient
show sticks, peptide_1jd5_b
create unbound_1jd4_a.surface, unbound_1jd4_a; color white, unbound_1jd4_a.surface; set transparency, 0.6, unbound_1jd4_a.surface; show_as surface, unbound_1jd4_a.surface; disable unbound_1jd4_a.surface
load unbound_1jd4_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_1jd4_a_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
load unbound_1jd4_a_out/pockets/pocket2_vert.pqr, pocket2_vert.pqr
load unbound_1jd4_a_out/pockets/pocket3_vert.pqr, pocket3_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_1jd5_b
