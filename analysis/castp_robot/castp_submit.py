#!/usr/bin/python

import os, sys, shutil, time
import re
import tarfile
import urllib, urllib2, cookielib
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
    tempfile=os.path.basename(file_path)
    copied=False
    if not os.access(tempfile, os.R_OK):
        shutil.copy(file_path, os.getcwd())
        copied=True
    fd = open(tempfile)
    # using visual=jmol to have the job ID in the response URL
    params = {'submit_file':'Submit', 'email': email_address, 'userfile' : fd}
    response = submit_form(url, params)
    if copied: os.remove(tempfile)
    fd.close()
    jid_index = response.url.index(CASTP_JID_PREFIX)
    jobid = response.url[jid_index:jid_index+CASTP_JID_LENGTH]
    '''
    return response
    success_pattern = re.compile('Results have been sent to')
    if not re.search(success_pattern, response_html):
        response.msg = 'FAIL'
        return None
    '''
    return response, jobid

def submit_form(form_url, params_dict):
    cookies = cookielib.CookieJar()
    opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cookies),
                                    MultipartPostHandler.MultipartPostHandler)
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
    response, jid = submit_pdbfile(pdbfile, email_address)
    received = False
    curr_wait=0
    received = castp_fetch.poll(jid)
    while not received and curr_wait<4:
        time.sleep(4)
        curr_wait += 1
        received = castp_fetch.poll(jid)
    if received:
        filenames = castp_fetch.fetch_by_keyword(jid)
        
    else:
        raise ValueError('Could not find results for %s on server' % jid)

if __name__ == '__main__':
    
    pdbid_pattern = re.compile('^[a-z0-9]{4}[a-z]?$', re.IGNORECASE)
    email_address = 'assaf.faragy@mail.huji.ac.il'
    for arg in sys.argv[1:]:
        response = None
        if arg.endswith('.pdb') and os.access(arg, os.R_OK):
            response = submit_pdbfile(arg, email_address)
            if response: print 'Submitted PDB file %s' % arg
        else:
            if len(arg)>=4 and pdbid_pattern.match(arg):
                pdbid = arg.lower()
                response = submit_pdbid(arg, email_address)
                if response: print 'Submitted PDB code %s' % arg
            else:
                print '%s is not a valid argument. Provide either a PDB code (with optional single chain) or a pdb file.' % arg
    print 'Done. Results will be sent to email %s' % email_address
    
