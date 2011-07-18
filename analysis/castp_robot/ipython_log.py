#log# Automatic Logger file. *** THIS MUST BE THE FIRST LINE ***
#log# DO NOT CHANGE THIS LINE OR THE TWO BELOW
#log# opts = Struct({'__allownew': True, 'logfile': 'ipython_log.py'})
#log# args = []
#log# It is safe to make manual edits below here.
#log#-----------------------------------------------------------------------
import email
sys.modules['email']
import sys, os
sys.modules['email']
from castp_submit import *
c=open_connection(True)
c.select()
typ, data = c.fetch(405, '(RFC822)')
data[0]
c.select()
typ, data = c.search(None, '(UNSEEN SUBJECT "CASTp")')
data
typ, data = c.fetch(401, '(RFC822)')
data
text=StringIO.StringIO(data[0][1]).read()
import StringIO
text=StringIO.StringIO(data[0][1]).read()
text
msg=email.message_from_string(text)
import email
import email as em
msg=em.message_from_string(text)
msg
msg.get_filename()
msg.get_charset()
msg.items()
msg
msg.get_params()
msg.get_payload()
atts=msg.get_payload()
atts[0]
a1=atts[1]
a1.as_string()
a1.is_multipart()
a1.get_content_type()
a1=atts[3]
a1.get_content_type()
a1=atts[0]
a1.get_content_type()
a1.get_content_type()=='text/plain'
a1.get_content_type()=='text/plainf'
a1=atts[3]
a1.get_params()
dict(a1.get_params())
a1.get_filename()
a1.get()
import mimetools
import multifile as mf
import mimetools as mt
msg=mt.Message(text)
msg=mt.Message(msg)
msg=mt.Message(StringIO.StringIO(data[0][1]))
msg.getplist()
msg.getheader()
msg.getheaders()
msg.headers
msg=em.message_from_string(text)
msg=mt.Message(msg)
msg=em.message_from_string(text)
msg.get_payload()
content=msg.get_payload()
msg.is_multipart()
msg.get_payload()[0].get_payload()
msg.get_payload()[1].get_payload()
att1=em.message_from_string(msg.get_payload()[1].get_payload())
att1
att1.get_payload()
msg.items()
from email.generator import Generator
fp = StringIO()
g = Generator(fp, mangle_from_=False, maxheaderlen=60)
g.flatten(msg)
fp = StringIO.StringIO()
from email.generator import Generator
g = Generator(fp, mangle_from_=False, maxheaderlen=60)
g.flatten(msg)
fp
fp.getvalue()
for part in msg.walk():
    print part.get_content_type()
    

for part in msg.walk():
    tp=part.get_content_type()
    if tp=='application/octet-stream':
        print part.getencoding()
        

for part in msg.walk():
    tp=part.get_content_type()
    if tp=='application/octet-stream':
        mimepart=mt.Message(part.as_string())
        print mimepart.getencoding()
        

for part in msg.walk():
    tp=part.get_content_type()
    if tp=='application/octet-stream':
        mimepart=mt.Message(StringIO.StringIO(part.as_string()))
print(mimepart.getencoding())
for part in msg.walk():
    tp=part.get_content_type()
    if tp=='application/octet-stream':
        mimepart=mt.Message(StringIO.StringIO(part.as_string()))
        print(mimepart.getencoding())
        

for part in msg.walk():
    tp=part.get_content_type()
    if tp=='application/octet-stream':
        mimepart=mt.Message(StringIO.StringIO(part.as_string()))
        mimeString=StringIO.StringIO(); mt.decode(mimepart, mimeString, mimepart.getencoding())
        

for part in msg.walk():
    tp=part.get_content_type()
    if tp=='application/octet-stream':
        mimepart=mt.Message(StringIO.StringIO(part.as_string()))
        mimeString=StringIO.StringIO(); mt.decode(mimepart.fp, mimeString, mimepart.getencoding())
        

for part in msg.walk():
    tp=part.get_content_type()
    if tp=='application/octet-stream':
        mimepart=mt.Message(StringIO.StringIO(part.as_string()))
        mimeString=StringIO.StringIO(); mt.decode(mimepart.fp, mimeString, mimepart.getencoding())
        mimeString.getvalue()
        

_ip.magic("logstart ")

for part in msg.walk():
    tp=part.get_content_type()
    if tp=='application/octet-stream':
        mimepart=mt.Message(StringIO.StringIO(part.as_string()))
        mimeString=open(part.get_filename, 'w'); mt.decode(mimepart.fp, mimeString, mimepart.getencoding())
        mimeString.close()
        
for part in msg.walk():
    tp=part.get_content_type()
    if tp=='application/octet-stream':
        mimepart=mt.Message(StringIO.StringIO(part.as_string()))
        mimeString=StringIO.StringIO(); mt.decode(mimepart.fp, mimeString, mimepart.getencoding())
        mimeString.getvalue()
for part in msg.walk():
    tp=part.get_content_type()
    if tp=='application/octet-stream':
        mimepart=mt.Message(StringIO.StringIO(part.as_string()))
        mimeString=StringIO.StringIO(); mt.decode(mimepart.fp, mimeString, mimepart.getencoding())
        fd=open(part.get_filename(), 'w'); print >>fd, mimeString.getvalue(); fd.close()
        
typ, data = c.search(None, '(UNSEEN SUBJECT "CASTp")')
c.close()
c=open_connection(True)
c.select()
typ, data = c.search(None, '(UNSEEN SUBJECT "CASTp")')
data
typ, data = c.search(None, '(UNSEEN SUBJECT "CASTp")')
data
typ, data = c.search(None, '(UNSEEN SUBJECT "CASTp")')
data
typ, data = c.search(None, '(UNSEEN SUBJECT "CASTp")')
data
c.select()
typ, data = c.search(None, '(UNSEEN SUBJECT "CASTp")')
data
typ, data = c.fetch(398, '(RFC822)')
data[0][1]
import email
msg=email.message_from_string(data[0][1])
msg.get_payload()
for part in msg.walk():
    tp=part.get_content_type()
    if tp=='application/octet-stream':
        mimepart=mt.Message(StringIO.StringIO(part.as_string()))
        mimeString=StringIO.StringIO(); mt.decode(mimepart.fp, mimeString, mimepart.getencoding())
        fd=open(part.get_filename(), 'w'); print >>fd, mimeString.getvalue(); fd.close()
typ, data = c.fetch(398, '(RFC822)')
typ
#?c.fetch?
typ, data = c.fetch(398, '(RFC822 BODYSTRUCTURE)')
msg=email.message_from_string(data[0][1])
msg.get_payload()
for part in msg.walk():
    tp=part.get_content_type()
    if tp=='application/octet-stream':
        mimepart=mt.Message(StringIO.StringIO(part.as_string()))
        mimeString=open(part.get_filename(), 'w'); mt.decode(mimepart.fp, mimeString, mimepart.getencoding())
        mimeString.close()
        
part.getparams()
#?part.getparams?
part.get_params()
part.get_filename()
part.get_payload(decode=1)
#?fd.write?
_ip.system("ls -F download")
_ip.system("ls -F download/")
_ip.system("ls -F ")
typ, data = c.search(None, '(UNSEEN SUBJECT "CASTp")')
c=open_connection(True)
typ, data = c.search(None, '(UNSEEN BODY "1eak")')
typ, data = c.search(None, '(UNSEEN TEXT "1eak")')
c=open_connection(True)
c.select()
typ, data = c.search(None, '(UNSEEN TEXT "1eak")')
data
typ, data = c.search(None, '(TEXT "1eak")')
data
c.close()
c=open_connection(True)
c.select()
typ, data = c.search(None, '(TEXT "1eak")')
data
typ, data = c.search(None, '(TEXT "pockets")')
data
typ, data = c.search(None, '(TEXT "dudermaninan")')
data
typ, data = c.search(None, '(TEXT "duder")')
data
c.close()
c=open_connection(True)
c.select()
typ, data = c.search(None, '(TEXT "dudermaninan")')
data
import imap_utils
import imap_utils
c=open_connection(True)
messages=imap_utils.getMsgs(c, 'duder')
len(messages)
len([ms for ms in messages])
import imap_utils
c.close()
c=open_connection(True)
messages=imap_utils.getMsgs(c, 'duder')
len([ms for ms in messages])
