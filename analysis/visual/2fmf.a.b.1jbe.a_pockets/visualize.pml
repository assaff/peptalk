load unbound_1jbe_a.pdb
load peptide_2fmf_b.pdb
color white, unbound_1jbe_a
color red, peptide_2fmf_b
show_as cartoon, all
orient
show sticks, peptide_2fmf_b
create unbound_1jbe_a.surface, unbound_1jbe_a; color white, unbound_1jbe_a.surface; set transparency, 0.6, unbound_1jbe_a.surface; show_as surface, unbound_1jbe_a.surface; disable unbound_1jbe_a.surface
load unbound_1jbe_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_1jbe_a_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_2fmf_b
