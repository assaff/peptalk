#!/vol/ek/assaff/bin/python

from prody import parsePDB, matchAlign, writePDB

peptidb_table_file = 'peptidb2.stable.csv'

pairs = [line.strip().split(',')[:5] for line in open(peptidb_table_file).readlines() if not line.startswith('#')]

#debug
#pairs = pairs[:2]

def select_chains(atoms, chains):
    only_letters = lambda c: c.isalpha()
    chains = filter(only_letters, list(''.join(chains)))
    return atoms.select('protein and ('+' or '.join(['chain '+c.upper() for c in chains]) + ')')


for p in pairs:
    (bound_pdb, bound_chn, peptide_chn, unbound_pdb, unbound_chn) = p
    bound = select_chains(parsePDB(bound_pdb), bound_chn+peptide_chn)
    unbound = select_chains(parsePDB(unbound_pdb), unbound_chn)

    align_results = matchAlign(bound, unbound)
    if not align_results:
        #raise IOError('cannot align bound and unbound')
        continue
    bound = align_results[0]
    
    bound_r = select_chains(bound, bound_chn)
    unbound_r = select_chains(unbound, unbound_chn)
    peptide = select_chains(bound, peptide_chn)
    
    writePDB('bound/%s.%s.pdb' % (bound_pdb, bound_chn), bound_r)
    #writePDB('%s.%s.pdb' % (unbound_pdb, unbound_chn), unbound_r)
    writePDB('%s.receptor.pdb' % unbound_pdb, unbound_r)
    writePDB('%s.peptide.pdb' % unbound_pdb, peptide)



