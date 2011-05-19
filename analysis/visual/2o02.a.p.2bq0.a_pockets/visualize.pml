load unbound_2bq0_a.pdb
load peptide_2o02_p.pdb
color white, unbound_2bq0_a
color red, peptide_2o02_p
show_as cartoon, all
orient
show sticks, peptide_2o02_p
create unbound_2bq0_a.surface, unbound_2bq0_a; color white, unbound_2bq0_a.surface; set transparency, 0.6, unbound_2bq0_a.surface; show_as surface, unbound_2bq0_a.surface; disable unbound_2bq0_a.surface
load unbound_2bq0_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_2bq0_a_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
load unbound_2bq0_a_out/pockets/pocket2_vert.pqr, pocket2_vert.pqr
load unbound_2bq0_a_out/pockets/pocket3_vert.pqr, pocket3_vert.pqr
load unbound_2bq0_a_out/pockets/pocket4_vert.pqr, pocket4_vert.pqr
load unbound_2bq0_a_out/pockets/pocket5_vert.pqr, pocket5_vert.pqr
load unbound_2bq0_a_out/pockets/pocket6_vert.pqr, pocket6_vert.pqr
load unbound_2bq0_a_out/pockets/pocket7_vert.pqr, pocket7_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_2o02_p
