'''
Created on Dec 17, 2010

@author: assaf
'''

import subprocess
import numpy as np

CLUSTERING_SCRIPT_PATH = '/home/assaff/workspace/peptalk/src/cluster_residues.py'

bfactor_spectrum = np.arange(0,1,.1)
diameter_spectrum = np.arange(4,20,1)

def run_test(**params):
    test_args = []
    for (k,v) in params.items():
        if type(v) is bool:
            test_args += [k]
        else:
            test_args += [k, v]
    subprocess.Popen([CLUSTERING_SCRIPT_PATH]+test_args)
    

def benchmark(hyper=False):
    i=1
    for bfactor in bfactor_spectrum:
        for diameter in diameter_spectrum:
            run_config = TestRun()
            run_config.d = diameter
            run_config.b = bfactor
            if hyper:
                run_config.s = ' '
            args = [CLUSTERING_SCRIPT_PATH]
            for option,value in run_config.__dict__.items():
                args += ['-%s' % option, str(value)]
            print i, args
            i+=1
    exit()
    subprocess.Popen()
    
if __name__ == '__main__':
    benchmark(hyper=True)