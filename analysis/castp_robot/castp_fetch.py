#!/usr/bin/python

import sys, os, imaplib, email, time, getpass
import tarfile
import imap_utils

hostn = 'imap.gmail.com'
addrs = raw_input('HUJI email address: ')
assert addrs.endswith('@mail.huji.ac.il')
psswd = getpass.getpass()
uname = addrs

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

def fetch_attachments(msg):
    filenames_retrieved = []
    for attachment_filename, attachment_content in imap_utils.getAttachments(msg, filename_filter=None):
        #print 'Saving %s...' % attachment_filename
        local_fd=open(attachment_filename, 'w')
        local_fd.write(attachment_content)
        local_fd.close()
        filenames_retrieved.append(attachment_filename)
    return filenames_retrieved
        
def fetch_by_keyword(kwd):
    c = imap_utils.open_connection(hostn, uname, psswd, verbose=True)
    messages = imap_utils.getMsgs(c, keyword=kwd)
    filenames = []
    for msg in messages:
        filenames += fetch_attachments(msg)
    c.logout()
    return filenames

def fetch_latest_unread():
    c = imap_utils.open_connection(hostn, uname, psswd, verbose=False)
    messages = list(imap_utils.getMsgs(c, keyword='CASTp', unread=True))
    filenames = []
    for msg in messages:
        msg_time = email.utils.mktime_tz(email.utils.parsedate_tz(msg['Date']))
        cur_time = time.time()
        # HACK: a time issue causes CASTp to send messages "from the future".
        #       I use this behavior to detect recently-sent emails.
        if cur_time > msg_time: continue
        filenames += fetch_attachments(msg)
    c.logout()
    return filenames
    
if __name__ == '__main__':
    
    pdbids = sys.argv[1:]
    for pdbid in pdbids:
        fetch_by_keyword(pdbid)
    
