#!/usr/bin/python

import os, sys, shutil, time
import re
import urllib, urllib2
import castp_fetch

CASTP_BASE_URL='http://sts.bioengr.uic.edu/castp/'
CASTP_QUERY_FORM='query_process.php'
CASTP_CALC_REQUEST_FORM='advcal.php'

def submit_pdbid(pdbid, email_address):
    url=CASTP_BASE_URL+CASTP_QUERY_FORM
    params= {'pdbid': pdbid, 'email': email_address, 'visual':'emailonly'} #, 'submitid' : 'Search'}
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
    params = {'submit_file':'Submit', 'email': email_address, 'visual':'emailonly', 'userfile' : fd}
    print params
    response = submit_form(url, params)
    if copied: os.remove(tempfile)
    fd.close()
    return response

def submit_form(form_url, params_dict):
    # submit the calculation request to castp
    params=urllib.urlencode(params_dict)
    req=urllib2.Request(form_url, params)
    response=urllib2.urlopen(req)
    return response
    
def submit_pdb_and_fetch(pdbid):
    email_address = castp_fetch.addrs
    
    query_pdbid(pdbid, email_address)
    time.sleep(10)
    castp_fetch.fetch_by_keyword(pdbid)

import httplib, mimetypes

def post_multipart(host, selector, fields, files):
    """
    Post fields and files to an http host as multipart/form-data.
    fields is a sequence of (name, value) elements for regular form fields.
    files is a sequence of (name, filename, value) elements for data to be uploaded as files
    Return the server's response page.
    """
    content_type, body = encode_multipart_formdata(fields, files)
    h = httplib.HTTP(host)
    h.putrequest('POST', selector)
    h.putheader('content-type', content_type)
    h.putheader('content-length', str(len(body)))
    h.endheaders()
    h.send(body)
    errcode, errmsg, headers = h.getreply()
    return h.file.read()

def encode_multipart_formdata(fields, files):
    """
    fields is a sequence of (name, value) elements for regular form fields.
    files is a sequence of (name, filename, value) elements for data to be uploaded as files
    Return (content_type, body) ready for httplib.HTTP instance
    """
    BOUNDARY = '----------ThIs_Is_tHe_bouNdaRY_$'
    CRLF = '\r\n'
    L = []
    for (key, value) in fields:
        L.append('--' + BOUNDARY)
        L.append('Content-Disposition: form-data; name="%s"' % key)
        L.append('')
        L.append(value)
    for (key, filename, value) in files:
        L.append('--' + BOUNDARY)
        L.append('Content-Disposition: form-data; name="%s"; filename="%s"' % (key, filename))
        L.append('Content-Type: %s' % get_content_type(filename))
        L.append('')
        L.append(value)
    L.append('--' + BOUNDARY + '--')
    L.append('')
    body = CRLF.join(L)
    content_type = 'multipart/form-data; boundary=%s' % BOUNDARY
    return content_type, body

def get_content_type(filename):
    return mimetypes.guess_type(filename)[0] or 'application/octet-stream'


if __name__ == '__main__':
    
    pdbid_pattern = re.compile('^[a-z0-9]{4}[a-z]?$', re.IGNORECASE)
    email_address = 'assaf.faragy@mail.huji.ac.il'
    for arg in sys.argv[1:]:
        if arg.endswith('.pdb') and os.access(arg, os.R_OK):
            submit_pdbfile(arg, email_address)
            print 'Submitted PDB file %s' % arg
        else:
            if len(arg)>=4 and pdbid_pattern.match(arg):
                pdbid = arg.lower()
                submit_pdbid(arg, email_address)
                print 'Submitted PDB code %s' % arg
            else:
                print '%s is not a valid argument. Provide either a PDB code (with optional single chain) or a pdb file.' % arg
    print 'Done. Results will be sent to email %s' % email_address
    
