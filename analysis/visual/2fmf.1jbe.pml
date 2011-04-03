load /vol/ek/share/pdb/fm/pdb2fmf.ent.gz, 2fmf
select bound, 2fmf and chain A
load /vol/ek/share/pdb/jb/pdb1jbe.ent.gz, 1jbe
select unbound, 1jbe and chain A
align polymer and name ca and bound, polymer and name ca and unbound, quiet=0, object="aln_bound_unbound", reset=1
select peptide, (2fmf within 8 of unbound) and not bound
deselect
color red, peptide
color green, bound
color blue, unbound
show_as cartoon, all
orient unbound;
create unb_surface, unbound; color white, unb_surface; set transparency, 0.6, unb_surface; show_as surface, unb_surface; hide everything, unb_surface
symexp sym, 1jbe, (1jbe), 5.0
show_as cartoon, sym*; color white, sym*
select crystal_contacts, br. sym* within 5.0 of unbound; color pink, crystal_contacts; deselect;
select suspects, unbound within 5.0 of crystal_contacts; deselect; color hotpink, suspects
center peptide
