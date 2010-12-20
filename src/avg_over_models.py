'''
Created on Dec 20, 2010

@author: assaf
'''

import batch_test
from itertools import groupby
from numpy import array


class TestResult:
    pass

def TestResultFromLine(line):
    line = line.split()
    test = TestResult()
    test.bfactor = round(float(line[1]),2)
    test.diameter = float(line[2])
    test.score = float(line[3]) 
    test.pdbfile = line[4]
    test.file_index = int(line[0])
    return test

def average_tests_over_dataset():
    raw_input = open(batch_test.HOME_PATH+'analysis/bfactor_diameter_scd.regular.tab')
    tests = [TestResultFromLine(line) for line in raw_input]
    raw_input.close()
    
    DIAMETERS = sorted(list(set([test.diameter for test in tests])))
    BFACTORS = sorted(list(set([test.bfactor for test in tests])))
    print DIAMETERS
    print BFACTORS

    groups = {}
    for test in tests:
#        print list(batch_test.BFACTOR_RANGE)
        test_config = (test.bfactor, test.diameter) 
#        if groups[test_config] is None:
#            groups[test_config] = [test]
#        else:
        groups[test_config] += [test]
        print groups[test_config]
            
#        print i,j
#        groups[i][j] = test
#    print groups[0][0]

if __name__ == '__main__':
    average_tests_over_dataset()
    