load unbound_2hpj_a.pdb
load peptide_2hpl_b.pdb
color white, unbound_2hpj_a
color red, peptide_2hpl_b
show_as cartoon, all
orient
show sticks, peptide_2hpl_b
create unbound_2hpj_a.surface, unbound_2hpj_a; color white, unbound_2hpj_a.surface; set transparency, 0.6, unbound_2hpj_a.surface; show_as surface, unbound_2hpj_a.surface; disable unbound_2hpj_a.surface
load unbound_2hpj_a_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_2hpj_a_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_2hpl_b
