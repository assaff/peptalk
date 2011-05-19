load unbound_3cm2_a.pdb
load peptide_1tw6_d.pdb
color white, unbound_3cm2_a
color red, peptide_1tw6_d
show_as cartoon, all
orient
show sticks, peptide_1tw6_d
create unbound_3cm2_a.surface, unbound_3cm2_a; color white, unbound_3cm2_a.surface; set transparency, 0.6, unbound_3cm2_a.surface; show_as surface, unbound_3cm2_a.surface; disable unbound_3cm2_a.surface
load unbound_3cm2_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_1tw6_d
