'''
Created on Dec 19, 2010

@author: assaf
'''
import os, sys
import numpy as np
from glob import glob
import subprocess

HOME_PATH = '/home/assaf/workspace/peptalk/'
CLUSTERING_SCRIPT = os.path.join(HOME_PATH, 'src/cluster_residues.py')
DATA_DIR = os.path.join(HOME_PATH, 'data/')
DIAMTER_RANGE = np.arange(4,24,1)
BFACTOR_RANGE = np.arange(0.3,0.9,.1)
FILES_TO_CLUSTER = glob(DATA_DIR+'????.results.pdb')

if __name__ == '__main__':
    
    assert os.path.exists(CLUSTERING_SCRIPT) and os.path.isfile(CLUSTERING_SCRIPT)
    assert os.path.exists(DATA_DIR) and os.path.isdir(DATA_DIR)
    
#    DIAMTER_RANGE = np.arange(16,15,-0.5)
#    BFACTOR_RANGE = np.arange(1,0,-.2)

    output_file = os.path.join(HOME_PATH, 'analysis', sys.argv[1])    
    RESULTS = open(output_file, 'w')
    RESULTS.close()
#    wrongs_file = output_file+'.wrong'
#    bad_clusterings = open(wrongs_file, 'w')
#    bad_clusterings.close()
    FILES_TO_CLUSTER = FILES_TO_CLUSTER[:20]
    print 'Total runs to be performed: %d' % (len(DIAMTER_RANGE) * len(BFACTOR_RANGE) * len(FILES_TO_CLUSTER))
    
    file_index = 0
    for pdbfile in FILES_TO_CLUSTER:
        for b in BFACTOR_RANGE:
            for d in DIAMTER_RANGE:
                result = subprocess.Popen(['python', CLUSTERING_SCRIPT,
                                           '-p', pdbfile, 
                                           '-d', str(d),
                                           '-b', str(b),
                                           ],stdout=subprocess.PIPE).communicate()
                if result[0] is not None:
                    score = result[0].strip()
                    RESULTS = open(output_file, 'a')
                    print >> RESULTS, '%d\t%.4f\t%.4f\t%s\t%s' % (file_index,b,d,score,pdbfile)
                    RESULTS.close()
#                else:
#                    bad_clusterings = open(wrongs_file,'a')
#                    print >> bad_clusterings, '%d\t%.4f\t%.4f\t%s\t%s' % (file_index,b,d,result[0].strip(),pdbfile)
#                    bad_clusterings.close()
#                    print '%d\t%.4f\t%.4f\t%s\t%s' % (file_index,b,d,result[0].strip(),pdbfile)
        file_index += 1
    
    print 'Done.'
    exit()