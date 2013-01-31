#!/vol/ek/assaff/bin/python

import sys, os
import urllib2, urllib, hmac
import optparse
import json

USERNAME='assaff'
SECRET = '6NGxVCbRFvwQssyywKNx'
DEFAULT_FTMAP_SERVER = 'http://genomics9.bu.edu:8090/api.php'

usage = """Usage: {0:s} [options]
""".format(sys.argv[0])
parser = optparse.OptionParser(usage=usage)
parser.add_option('-s','--server', default=DEFAULT_FTMAP_SERVER, help='Address of server')
parser.add_option('-f','--protein', help='Protein file')
parser.add_option('-p','--protpdb',help='Protein pdb id')
parser.add_option('-m','--protmask',help='Protein mask')
parser.add_option('-j','--jobname',help='Job name')
parser.add_option('-c','--protchains',help='Chains for protein')
parser.add_option('-i','--ppimode',help='Use PPI mode')
'''parser.add_option('-e', '--examples', dest='examples', action='store_true', 
                  default=False, 
                  help='show usage examples and exit')
            
usage_examples="""
Example for http://genomics9.bu.edu:8090/api.php:
{0:s} -s 'http://genomics9.bu.edu:8090/api.php' -pp 1ela  -pc a -j 'elastase test'
""".format(sys.argv[0])'''
    
opt, args = parser.parse_args()
'''if opt.examples:
    print 'Usage Examples:\n', usage_examples
    sys.exit(-1)
'''
if opt.protein and not os.access(opt.protein, os.R_OK):
    parser.error('Protein file not found')
if opt.protmask and not os.access(opt.protmask, os.R_OK):
    parser.error('Protein mask file not found')
if not opt.protein and not opt.protpdb:
    parser.error('No protein specified')
if opt.protein and opt.protpdb:
    parser.error('Please only specify a protein or protein pdb id')

opt.useprotpdbid = '0' if opt.protein else '1';
opt.username = USERNAME


params=dict([(k,str(v)) for k,v in opt.__dict__.items() if v])

'''
params={}
params['protpdb']=opt.protpdb
params['protchains']=chid
params['jobname']=jobname
params['username']=username
params['server']= 'http://'+server+'/api.php'
'''

sig_string=''.join([k+v for k,v in sorted(params.items(), key=lambda x: x[0])])
params['sig']=hmac.new(SECRET, sig_string).hexdigest()

files = []
if opt.protein:
    protein_fd = open(opt.protein)
    opt.prot = protein_fd
    del opt.protein
    files.append(protein_fd)
if opt.protmask:
    mask_fd = open(opt.protmask)
    opt.protmask = mask_fd
    files.append(mask_fd)

response=urllib2.urlopen(params['server'], urllib.urlencode(params))

# close all open file handles
for fh in files: fh.close()

# parse the response:
if response.code != 200:
    print "Submit failed"
    exit(1)
else:
    response_data = json.loads(response.readline())
    if response_data['status']==u'success':
        job_id = int(response_data['id'])
        print 'Job_ID\t%d' % job_id
    else:
        print 'Failed.'
        print 'Response from FTMap server:', response_data
