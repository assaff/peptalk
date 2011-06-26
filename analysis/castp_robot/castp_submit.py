#!/usr/bin/python

import os, sys, shutil, time
import re
import tarfile
import urllib, urllib2, cookielib, httplib
import MultipartPostHandler

import castp_fetch

CASTP_BASE_URL='http://sts.bioengr.uic.edu/castp/'
CASTP_QUERY_FORM='query_process.php'
CASTP_CALC_REQUEST_FORM='advcal.php'

CASTP_JID_PREFIX = 'JID'
CASTP_JID_LENGTH = 11

def submit_pdbid(pdbid, email_address):
    url=CASTP_BASE_URL+CASTP_QUERY_FORM
    params= {'pdbid': pdbid, 'email': email_address, 'visual':'emailonly', 'submitid' : 'Search'}
    response = submit_form(url, params)
    response_html = response.read()
    success_pattern = re.compile('All result files have been sent to %s' % email_address)
    if not re.search(success_pattern, response_html):
        response.msg = 'FAIL'
    return response
    

def submit_pdbfile(file_path, email_address):
    url=CASTP_BASE_URL + CASTP_CALC_REQUEST_FORM
    if not os.access(file_path, os.R_OK):
        raise IOError('file %s does not exist or is not readable')
    fd = open(file_path)
    # using visual=jmol to have the job ID in the response URL
    params = {'submit_file':'Submit','userfile' : fd, 'visual':'emailonly','email': email_address}
    response = submit_form(url, params)
    fd.close()
    return response
    '''
    jid_index = response.url.index(CASTP_JID_PREFIX)
    jobid = response.url[jid_index:jid_index+CASTP_JID_LENGTH]
    return response
    success_pattern = re.compile('Results have been sent to')
    if not re.search(success_pattern, response_html):
        response.msg = 'FAIL'
        return None
    return response, jobid
    '''

def submit_form(form_url, params_dict):
    httplib.HTTPConnection.debuglevel = 1
    cookies = cookielib.CookieJar()
    opener = urllib2.build_opener(MultipartPostHandler.MultipartPostHandler)
    response= opener.open(form_url, params_dict)
    # submit the calculation request to castp
    return response
    
def submit_pdbid_and_fetch(pdbid):
    email_address = castp_fetch.addrs
    submit_pdbid(pdbid, email_address)
    time.sleep(10)
    castp_fetch.fetch_by_keyword(pdbid)
    
def submit_pdbfile_and_fetch(pdbfile):
    email_address = castp_fetch.addrs
    response = submit_pdbfile(pdbfile, email_address)
    #time.sleep(5)
    attachments = castp_fetch.fetch_latest_unread()
    curr_wait=0
    while len(attachments) == 0 and curr_wait<4:
        time.sleep(4)
        curr_wait += 1
        attachments += castp_fetch.fetch_latest_unread()
    if len(attachments) > 0:
        assert len(attachments)==1
        return attachments
    else:
        raise ValueError('Could not find results for %s on server' % jid)

if __name__ == '__main__':
    
    pdbid_pattern = re.compile('^[a-z0-9]{4}[a-z]?$', re.IGNORECASE)
    file2jid = {}
    for arg in sys.argv[1:]:
        if arg.endswith('.pdb') and os.access(arg, os.R_OK):
            try:
                attachments = submit_pdbfile_and_fetch(arg)
                #print 'Submitted PDB file %s, attachments retreived: %s' % (arg, attachments[0])
                file2jid[arg] = attachments[0][:-7]
            except ValueError:
                raise
        else:
            if len(arg)>=4 and pdbid_pattern.match(arg):
                pdbid = arg.lower()
                response = submit_pdbid(arg, email_address)
                if response: print 'Submitted PDB code %s' % arg
            else:
                print '%s is not a valid argument. Provide either a PDB code (with optional single chain) or a pdb file.' % arg
    for k,v in file2jid.items():
        print '%s\t%s' % (k,v)
    #print 'Done.'
    
