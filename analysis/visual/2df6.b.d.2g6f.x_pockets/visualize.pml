load unbound_2g6f_x.pdb
load peptide_2df6_d.pdb
color white, unbound_2g6f_x
color red, peptide_2df6_d
show_as cartoon, all
orient
show sticks, peptide_2df6_d
create unbound_2g6f_x.surface, unbound_2g6f_x; color white, unbound_2g6f_x.surface; set transparency, 0.6, unbound_2g6f_x.surface; show_as surface, unbound_2g6f_x.surface; disable unbound_2g6f_x.surface
load unbound_2g6f_x_out/pockets/pocket*vert.pqr, pocket*vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_2df6_d
