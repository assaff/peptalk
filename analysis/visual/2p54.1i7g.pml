load 2p54.pdb
select bound, 2p54 and chain A
load 1i7g.pdb
select unbound, 1i7g and chain A
align polymer and name ca and unbound, polymer and name ca and bound, quiet=0, object="aln_bound_unbound", reset=1
select peptide, (2p54 within 8 of unbound) and not bound
deselect
color magenta, peptide
color yellow, bound
color blue, unbound
show_as cartoon, all
orient bound
create unb_surface, unbound; color white, unb_surface; set transparency, 0.6, unb_surface; show_as surface, unb_surface;
