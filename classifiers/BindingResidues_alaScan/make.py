#!/usr/bin/python

import os, sys
from glob import glob
import decimal as dec
from decimal import Decimal

dec.getcontext().prec = 5 # set precision to 3 decimals
#MINIMUM_BINDERS = 4
alaScanDir = '/vol/ek/assaff/workspace/peptalk/data/peptiDB/bound/alaScan'
ddgThreshold = float(1.0)
try: ddgThreshold = float(sys.argv[1])
except: pass

aaCodeDict = {
         'A' : 'ALA',
		 'C' : 'CYS',
		 'D' : 'ASP',
		 'E' : 'GLU',
		 'F' : 'PHE',
		 'G' : 'GLY',
		 'H' : 'HIS',
		 'I' : 'ILE',
		 'K' : 'LYS',
		 'L' : 'LEU',
		 'M' : 'MET',
		 'N' : 'ASN',
		 'P' : 'PRO',
		 'Q' : 'GLN',
		 'R' : 'ARG',
		 'S' : 'SER',
		 'T' : 'THR',
		 'V' : 'VAL',
		 'W' : 'TRP',
		 'Y' : 'TYR'
		 }
aaNumDict = dict(zip(range(1, len(aaCodeDict.keys()) + 1), sorted(aaCodeDict.keys())))

alaScanSet = set([os.path.basename(filename)[:4] for filename in glob(alaScanDir + '/????.res')])
dataSet = set([line.strip() for line in open('../pdb_list.txt').readlines()])

assert alaScanSet.issuperset(dataSet), 'alanine scanning data does not cover the whole data set'

(RES_NAME, RES_NUM, RES_DDG_BIND) = range(3)

def getBindersFromResfile(filename, ddg_threshold):
    fh = open(filename)
    lines = [line.strip().split() for line in fh.readlines() if line.startswith('DDG_BIND')]
    lines = filter(lambda line: line[23].endswith('A'), lines)
#    lines.sort(key=lambda line: float(line[13]), reverse=True)
#    for line in lines[:4]:
#        print '\t'.join(line)
#    return []
    binders = [(aaCodeDict[line[24][0]], line[23].strip('A'), Decimal(line[13])) 
               for line in lines 
               if float(line[13]) > 0]
#               if float(line[13])>=ddg_threshold or lines.index(line)<MINIMUM_BINDERS]
#    print 'resFile', os.path.basename(filename) #, binders
#    for r in binders: print r[0],r[1],r[2], filename
    return binders

def getBindersFromAlascanFile(filename, ddg_threshold):
    fh = open(filename)
    results_lines = [line.strip().split() for line in fh.readlines()[3:]]
    results_lines = filter(lambda line: line[1]=='A', results_lines)
#    results_lines.sort(key=lambda line: float(line[5]), reverse=True)
    binders = [(aaCodeDict[aaNumDict[int(line[4])]], line[3], Decimal(line[5])) 
               for line in results_lines 
               if float(line[5]) > 0]
#               if float(line[5]) >= ddgThreshold]
#    print 'alascanFile', os.path.basename(filename) #, binders
#    for r in binders: print r[0],r[1],r[2], filename
    return binders

if __name__=='__main__':
#    print 'using DDG_BIND threshold:', ddgThreshold
    for pdbid in sorted(list(dataSet.intersection(alaScanSet))):
        
        resFilename = os.path.abspath(os.path.join(alaScanDir, pdbid + '.res'))
        alascanResultsFilename = os.path.abspath(os.path.join(alaScanDir, pdbid + '.alascan.results'))
        binders = []
        try: 
            binders = getBindersFromAlascanFile(alascanResultsFilename, ddgThreshold)
        except IOError:
            try:
                binders = getBindersFromResfile(resFilename, ddgThreshold)
            except IOError: raise
#        assert len(binders)>0 
        if len(binders)==0:
            print 'Both sources for %s did not find any hot spots. Cleaning up and aborting.' % pdbid
            for resfile in glob(os.getcwd()+'*.res'):
                os.remove(resfile)
            print 'Done.'
            exit(1)
        outputFilename = os.path.join(os.getcwd(), pdbid + '.res')
        fh = open(outputFilename, 'w')
        for res in binders:
            print >> fh, res[RES_NAME], res[RES_NUM], res[RES_DDG_BIND]
        fh.close()
    		 
