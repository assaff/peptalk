load unbound_2ds5_ab.pdb
load peptide_2ds8_qp.pdb
color white, unbound_2ds5_ab
color red, peptide_2ds8_qp
show_as cartoon, all
orient
show sticks, peptide_2ds8_qp
create unbound_2ds5_ab.surface, unbound_2ds5_ab; color white, unbound_2ds5_ab.surface; set transparency, 0.6, unbound_2ds5_ab.surface; show_as surface, unbound_2ds5_ab.surface; disable unbound_2ds5_ab.surface
load unbound_2ds5_ab_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_2ds8_qp
