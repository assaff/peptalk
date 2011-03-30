load 1elw.pdb
select bound, 1elw and chain A
load 1a17.pdb
select unbound, 1a17 and chain A
align polymer and name ca and unbound, polymer and name ca and bound, quiet=0, object="aln_bound_unbound", reset=1
select peptide, (1elw within 8 of unbound) and not bound
deselect
color magenta, peptide
color yellow, bound
color blue, unbound
show_as cartoon, all
orient bound
create unb_surface, unbound; color white, unb_surface; set transparency, 0.6, unb_surface; show_as surface, unb_surface;
