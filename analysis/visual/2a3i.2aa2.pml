load /vol/ek/share/pdb/a3/pdb2a3i.ent.gz, 2a3i
select bound, 2a3i and chain A
load /vol/ek/share/pdb/aa/pdb2aa2.ent.gz, 2aa2
select unbound, 2aa2 and chain A
align polymer and name ca and bound, polymer and name ca and unbound, quiet=0, object="aln_bound_unbound", reset=1
select peptide, (2a3i within 8 of unbound) and not bound
deselect
color red, peptide
color green, bound
color blue, unbound
show_as cartoon, all
orient unbound;
create unb_surface, unbound; color white, unb_surface; set transparency, 0.6, unb_surface; show_as surface, unb_surface; hide everything, unb_surface
symexp sym, 2aa2, (2aa2), 5.0
show_as cartoon, sym*; color white, sym*
select crystal_contacts, br. sym* within 5.0 of unbound; color pink, crystal_contacts; deselect;
select suspects, unbound within 5.0 of crystal_contacts; deselect; color hotpink, suspects
center peptide
