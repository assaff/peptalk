load unbound_1pdr_a.pdb
load peptide_1tp5_b.pdb
color white, unbound_1pdr_a
color red, peptide_1tp5_b
show_as cartoon, all
orient
show sticks, peptide_1tp5_b
create unbound_1pdr_a.surface, unbound_1pdr_a; color white, unbound_1pdr_a.surface; set transparency, 0.6, unbound_1pdr_a.surface; show_as surface, unbound_1pdr_a.surface; disable unbound_1pdr_a.surface
load unbound_1pdr_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_1tp5_b
