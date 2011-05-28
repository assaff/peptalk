#!/usr/bin/python

import sys, os, imaplib, email
import ConfigParser
import imap_utils

config = ConfigParser.ConfigParser()
config.read([os.path.expanduser('./.pymail')])

hostn = config.get('server', 'hostname')
uname = config.get('account', 'username')
psswd = config.get('account', 'password')
addrs = config.get('account', 'email')

def fetch_by_keyword(kwd):
    c = imap_utils.open_connection(hostn, uname, psswd, verbose=True)
    messages = imap_utils.getMsgs(c, keyword=kwd)
    for msg in messages:
        for attachment_filename, attachment_content in imap_utils.getAttachments(msg, filename_filter=None):
            print 'Saving %s...' % attachment_filename
            local_fd=open(attachment_filename, 'w')
            local_fd.write(attachment_content)
            local_fd.close()
    c.logout()
    
if __name__ == '__main__':
    
    pdbids = sys.argv[1:]
    for pdbid in pdbids:
        fetch_by_keyword(pdbid)
    
