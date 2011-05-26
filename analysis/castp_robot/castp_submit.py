#!/usr/bin/python

import os, sys, time
import urllib, urllib2
import castp_fetch

CASTP_URL='http://sts.bioengr.uic.edu/castp/advcal.php'

def submit_pdb_castp(pdbid, email_address):
    values= {'pdbid': pdbid, 'email': email_address, 'visual':'emailonly', 'hetopt':'on'}
    return submit_form(values)



def submit_form(field_values):
    # submit the calculation request to castp
    params=urllib.urlencode(field_values)
    req=urllib2.Request(CASTP_URL, params)
    response=urllib2.urlopen(req)
    
    if response.getcode()!=200:
        raise IOError('Bad response from CASTp for %s query.' % pdbid)
    
def submit_pdb_and_fetch(pdbid)
    email_address = castp_fetch.addrs
    
    submit_pdb_castp(pdbid, email_address)
    time.sleep(10)
    castp_fetch.fetch_by_keyword(pdbid)
    
    
    '''
    c = open_connection(verbose=True)
    if c is None: exit(1)
    
    
    c.select()
    typ, data = c.search(None, 'ALL')
    for num in data[0].split():
        typ, msg_data = c.fetch(num, '(RFC822)')
        #   print 'Message %s\n%s\n' % (num, msg_data[0][1])
        msg=email.message_from_string(msg_data[0][1])
        #print msg.items()
        
        if not msg.is_multipart():
            continue
            #raise IOError('email message from CASTp does not carry an attachment.')
        for msg_part in msg.walk():
            if msg_part.get_content_type() == 'application/octet-stream': #attachments
                local_filename = msg_part.get_filename()
                print 'Saving %s...' % local_filename
                local_fd=open('download/'+local_filename, 'w')
                local_fd.write(msg_part.get_payload(decode=1))
                local_fd.close()
    c.logout()
    exit()
    try:
        print c
    finally:
        c.logout()
    '''
