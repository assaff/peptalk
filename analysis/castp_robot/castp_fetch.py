#!/usr/bin/python

import sys, os, imaplib, email
import tarfile
import ConfigParser
import imap_utils

config = ConfigParser.ConfigParser()
config.read([os.path.expanduser('./.pymail')])

hostn = config.get('server', 'hostname')
uname = config.get('account', 'username')
psswd = config.get('account', 'password')
addrs = config.get('account', 'email')


def poll(keyword, verbose=False):
    c = imap_utils.open_connection(hostn, uname, psswd, verbose=verbose)
    messages = imap_utils.getMsgs(c, keyword=keyword)
    for msg in messages: return True
    return False

def fetch_by_job_id(jid):
    filename_list = fetch_by_keyword(jid)
    assert len(filename_list)==1
    filename = filename_list[0]
    assert filename == '%s.tar.gz' % jid
    tf = tarfile.open(filename, mode='r:gz')
    return tf

def fetch_by_keyword(kwd):
    c = imap_utils.open_connection(hostn, uname, psswd, verbose=True)
    messages = imap_utils.getMsgs(c, keyword=kwd)
    filenames_retrieved = []
    for msg in messages:
        for attachment_filename, attachment_content in imap_utils.getAttachments(msg, filename_filter=None):
            print 'Saving %s...' % attachment_filename
            local_fd=open(attachment_filename, 'w')
            local_fd.write(attachment_content)
            local_fd.close()
            filenames_retrieved.append(attachment_filename)
    c.logout()
    return filenames_retrieved
    
if __name__ == '__main__':
    
    pdbids = sys.argv[1:]
    for pdbid in pdbids:
        fetch_by_keyword(pdbid)
    
