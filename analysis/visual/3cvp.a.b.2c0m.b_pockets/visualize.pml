load unbound_2c0m_b.pdb
load peptide_3cvp_b.pdb
color white, unbound_2c0m_b
color red, peptide_3cvp_b
show_as cartoon, all
orient
show sticks, peptide_3cvp_b
create unbound_2c0m_b.surface, unbound_2c0m_b; color white, unbound_2c0m_b.surface; set transparency, 0.6, unbound_2c0m_b.surface; show_as surface, unbound_2c0m_b.surface; disable unbound_2c0m_b.surface
load unbound_2c0m_b_out/pockets/pocket0_vert.pqr, pocket0_vert.pqr
load unbound_2c0m_b_out/pockets/pocket1_vert.pqr, pocket1_vert.pqr
load unbound_2c0m_b_out/pockets/pocket2_vert.pqr, pocket2_vert.pqr
load unbound_2c0m_b_out/pockets/pocket3_vert.pqr, pocket3_vert.pqr
load unbound_2c0m_b_out/pockets/pocket4_vert.pqr, pocket4_vert.pqr
load unbound_2c0m_b_out/pockets/pocket5_vert.pqr, pocket5_vert.pqr
alter pocket*, vdw=vdw+1.4
show_as mesh, pocket*
color orange, pocket*
center peptide_3cvp_b
