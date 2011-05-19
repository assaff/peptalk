load unbound_2yql_a.pdb
load peptide_2puy_e.pdb
color white, unbound_2yql_a
color red, peptide_2puy_e
show_as cartoon, all
orient
show sticks, peptide_2puy_e
create unbound_2yql_a.surface, unbound_2yql_a; color white, unbound_2yql_a.surface; set transparency, 0.6, unbound_2yql_a.surface; show_as surface, unbound_2yql_a.surface; disable unbound_2yql_a.surface
load unbound_2yql_a_out/pockets/pocket*vert.pqr, pocket*vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_2puy_e
