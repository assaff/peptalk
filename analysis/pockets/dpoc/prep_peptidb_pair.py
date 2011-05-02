#!/usr/bin/python

# Tell PyMOL we don't want any GUI features.
import __main__
__main__.pymol_argv = [ 'pymol', ]
 
# Importing the PyMOL module will create the window.
 
import pymol
 
# Call the function below before using any PyMOL modules.
 
pymol.finish_launching()
from pymol import cmd
import sys
print sys.argv

def insert_plus(s):
    return '+'.join(list(s))


(b_id, b_rec_chain, b_pep_chain, ub_id, ub_rec_chain) = sys.argv[1].split(',')

b_rec_chain_pml = insert_plus(b_rec_chain)
b_pep_chain_pml = insert_plus(b_pep_chain)
ub_rec_chain_pml = insert_plus(ub_rec_chain)

cmd.do('run /cs/grad/assaff/miro/bin/scripts/pymol/fetch_local.py')
cmd.do('run kabsch.py')
cmd.do('fetch %s' % b_id)
cmd.do('fetch %s' % ub_id)
cmd.do('select b_rec, polymer and %s and chain %s' % (b_id, b_rec_chain_pml))
cmd.do('select ub_rec, polymer and %s and chain %s' % (ub_id, ub_rec_chain_pml) )
cmd.do('select b_pep, polymer and %s and chain %s' % (b_id, b_pep_chain_pml))
cmd.do("optAlign polymer and name ca and (ub_rec), polymer and name ca and (b_rec)")
cmd.alter('(b_pep)',"resn='PEP'")
cmd.alter('(b_pep)',"type='HETATM'")
cmd.do('select ub_and_pep, ub_rec or b_pep')
#cmd.do('orient')
cmd.save('%s.pdb' 
            % '.'.join([ub_id,ub_rec_chain,b_id,b_pep_chain]),'((ub_and_pep))')
#cmd.save('/a/warhol-00/h/miro/ek/assaff/workspace/peptalk/analysis/pockets/dpoc/ub_rec2.pdb','((ub_rec))')
#cmd.save('/a/warhol-00/h/miro/ek/assaff/workspace/peptalk/analysis/pockets/dpoc/b_pep2.pdb','((b_pep))')
