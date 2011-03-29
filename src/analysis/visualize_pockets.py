#!/usr/bin/python

import sys, os, subprocess
from glob import glob

pdbfilename=sys.argv[1]
subprocess.Popen(['fpocket','-f', pdbfilename]).communicate()   
orig_pockets_lib=os.path.abspath(pdbfilename[:-4]+'_out')
tmp_pockets_lib='/tmp/fpockets_%d' % os.getpid()
import shutil
shutil.move(orig_pockets_lib, tmp_pockets_lib)
pocket_pdbs = glob(tmp_pockets_lib+'/pockets/pocket*.pdb')
for pocket_pdb in pocket_pdbs:
    pocket_name = 'pocket%d' % pocket_pdbs.index(pocket_pdb)
    print 'load %s, %s' % (pocket_pdb, pocket_name)
    print 'show_as mesh, %s' % pocket_name
    print 'color blue, %s' % pocket_name


