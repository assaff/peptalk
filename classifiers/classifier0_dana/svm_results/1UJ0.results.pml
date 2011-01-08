load 1UJ0.results.pdb

bg white
hide everything

select peptide, chain B
deselect
select receptor, chain A
deselect
#select backbone, name c+n+o+ca and !het and !peptide
#deselect
#select prot, !het and !peptide
#deselect

cmd.spectrum('b', 'blue_white_red', selection='receptor')

color yellow, peptide
show sticks, peptide
show spheres, receptor
