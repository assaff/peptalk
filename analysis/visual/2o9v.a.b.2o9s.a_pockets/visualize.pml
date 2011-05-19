load unbound_2o9s_a.pdb
load peptide_2o9v_b.pdb
color white, unbound_2o9s_a
color red, peptide_2o9v_b
show_as cartoon, all
orient
show sticks, peptide_2o9v_b
create unbound_2o9s_a.surface, unbound_2o9s_a; color white, unbound_2o9s_a.surface; set transparency, 0.6, unbound_2o9s_a.surface; show_as surface, unbound_2o9s_a.surface; disable unbound_2o9s_a.surface
load unbound_2o9s_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_2o9v_b
