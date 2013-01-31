#!/vol/ek/assaff/bin/python

import sys, os
import urllib2, urllib, hmac
import optparse
import json

USERNAME='assaff'
SECRET = '6NGxVCbRFvwQssyywKNx'
DEFAULT_FTMAP_SERVER = 'http://genomics9.bu.edu:8090/api_download.php'

usage = """Usage: {0:s} [options]
""".format(sys.argv[0])
parser = optparse.OptionParser(usage=usage)
parser.add_option('-s','--server', default=DEFAULT_FTMAP_SERVER, help='Address of server')
parser.add_option('-j','--jobid',type='int', help='Job ID')
parser.add_option('-o','--output-file',help='name for output file, defaults to \'fftmap.<JOBID>.pdb.gz\'')
'''parser.add_option('-e', '--examples', dest='examples', action='store_true', 
                  default=False, 
                  help='show usage examples and exit')
            
usage_examples="""
Example for http://genomics9.bu.edu:8090/api_download.php:
{0:s} -s 'http://genomics9.bu.edu:8090/api_download.php' -j 30
""".format(sys.argv[0])'''
    
opt, args = parser.parse_args()
'''if opt.examples:
    print 'Usage Examples:\n', usage_examples
    sys.exit(-1)
'''
if not opt.jobid:
    parser.error('No job ID specified')

DEFAULT_OUTPUT_FILE = 'fftmap.'+str(opt.jobid)+'.pdb.gz'
output_file = opt.output_file if opt.output_file else DEFAULT_OUTPUT_FILE

opt.username = USERNAME
server = opt.server
del opt.server

params=dict([(k,v) for k,v in opt.__dict__.items() if v])

sig_string=''.join([k+str(v) for k,v in sorted(params.items(), key=lambda x: x[0])])
params['sig']=hmac.new(SECRET, sig_string).hexdigest()

response=urllib2.urlopen(server, urllib.urlencode(params))

# parse the response:
if response.code != 200:
    print "Download failed."
    exit(1)
else:
    response_body = response.read()
    fh=open(output_file, 'w')
    fh.write(response_body)
    fh.close()
    print output_file
