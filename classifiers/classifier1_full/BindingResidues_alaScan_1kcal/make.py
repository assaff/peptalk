#!/usr/bin/python

import os,sys
from glob import glob

alaScanDir='/vol/ek/assaff/workspace/peptalk/data/peptiDB/bound/alaScan'
ddgThreshold=float(1.0)
try: ddgThreshold=float(sys.argv[1])
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
aaNumDict = dict(zip(range(1,len(aaCodeDict.keys())+1), sorted(aaCodeDict.keys())))

alaScanSet = set([os.path.basename(filename)[:4] for filename in glob(alaScanDir+'/????.res')])
dataSet = set([line.strip() for line in open('../pdb_list.txt').readlines()])

assert alaScanSet.issuperset(dataSet), 'alanine scanning data does not cover the whole data set'

resFilenames = sorted([os.path.abspath(os.path.join(alaScanDir,pdbid+'.res')) for pdbid
                 in dataSet.intersection(alaScanSet)])
                 
def getBindersFromResfile(filename, ddg_threshold):
    try:
        fh = open(filename)
        lines = [line.strip().split() for line in fh.readlines() if line.startswith('DDG_BIND')]
        binders = [(aaCodeDict[line[24][0]],line[23].strip('A')) for line 
                    in lines if line[23].endswith('A') and 
                    float(line[13])>=ddg_threshold]
        return binders
    except:
        raise IOError

def getBindersFromAlascanFile(filename, ddg_threshold):
    try:
        fh = open(filename)
        results_lines = [line.strip().split() for line in fh.readlines()[3:]]
        binders = [(aaCodeDict[aaNumDict[int(line[4])]],line[3]) for line in lines if (line[1]=='A' and float(line[5])>=ddgThreshold)]
        return binders
    except:
        raise IOError

print 'using DDG_BIND threshold:', ddgThreshold
for resFilename in resFilenames:
    #print 'reading alaScan file:', resFilename
    pdbid=os.path.basename(resFilename)[:4]
    
    alascanResultsFile = os.path.abspath(os.path.join(alaScanDir,pdbid+'.alascan.results'))
    try: binders = getBindersFromAlascanFile(alascanResultsFile, ddgThreshold)
    except:
        binders = getBindersFromResfile(resFilename, ddgThreshold)
    if len(binders)==0:
        print >> sys.stdout, 'could not find any hot spots for %s' % pdbid
        continue

    outputFilename = os.path.join(os.getcwd(),pdbid+'.res')
    fh = open(outputFilename, 'w')
    for res in binders:
        print>>fh, res[0],res[1]
    fh.close()
		 
