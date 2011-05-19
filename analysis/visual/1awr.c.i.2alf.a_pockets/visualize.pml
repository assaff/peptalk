load unbound_2alf_a.pdb
load peptide_1awr_i.pdb
color white, unbound_2alf_a
color red, peptide_1awr_i
show_as cartoon, all
orient
show sticks, peptide_1awr_i
create unbound_2alf_a.surface, unbound_2alf_a; color white, unbound_2alf_a.surface; set transparency, 0.6, unbound_2alf_a.surface; show_as surface, unbound_2alf_a.surface; disable unbound_2alf_a.surface
load unbound_2alf_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_2alf_a_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
load unbound_2alf_a_out/pockets/pocket2_vert.pqr, pocket2_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_1awr_i
