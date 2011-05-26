#!/usr/bin/python

import getpass, os, imaplib, email

def open_connection(hostname, username, password, verbose=False):
    # Connect to the server
    if verbose: print 'Connecting to', hostname
    connection = imaplib.IMAP4_SSL(hostname)

    # Login to our account
    if verbose: print 'Logging in as', username
    connection.login(username, password)
    return connection

def getMsgs(connection, keyword='', unread=False):
  connection.select('Inbox')
  imap_search_string = ''
  if unread: imap_search_string += 'UNSEEN '
  imap_search_string += 'TEXT "%s"' % keyword
  typ, data = connection.search(None, '(%s)' % imap_search_string)
  for num in data[0].split():
    typ, data = connection.fetch(num,'(RFC822)')
    msg = email.message_from_string(data[0][1])
    typ, data = connection.store(num,'-FLAGS','\\Seen')
    yield msg

def getAttachments(msg, filename_filter=None):
  for part in msg.walk():
    if part.get_content_type() == 'application/octet-stream':
      if (filename_filter is None) or (filename_filter(part.get_filename())):
          yield part.get_filename(), part.get_payload(decode=1)


