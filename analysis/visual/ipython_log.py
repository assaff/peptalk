#log# Automatic Logger file. *** THIS MUST BE THE FIRST LINE ***
#log# DO NOT CHANGE THIS LINE OR THE TWO BELOW
#log# opts = Struct({'__allownew': True, 'logfile': 'ipython_log.py'})
#log# args = []
#log# It is safe to make manual edits below here.
#log#-----------------------------------------------------------------------
%logstart%
_ip.magic("logstart ")

import urllib, urllib2
castp_url='http://sts.bioengr.uic.edu/castp/advcal.php'
values= {'pdbid': '2hwq', 'email':'assaff@cs.huji.ac.il', 'visual':'emailonly'}
data=urllib.urlencode(values)
req=urllib2.Request(castp_url, data)
response=urllib2.urlopen(req)
the_page=response.read()
print(the_page)
open('castp_test_output.html','w')
fd=open('castp_test_output.html','w')
print>>fd, the_page
fd.close()
respones
response
response.msg
response.next 
response.next()
response.fp
response.__dict__
response.__dict__['headers']
print(response.headers)
response.getcode 
response.getcode()
response.readlines()
response.read()
response=urllib2.urlopen(req)
#?response.read?
import sys
sys.path.append('../pockets')
