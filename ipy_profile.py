include ipythonrc

# cancel earlier logfile invocation:

logfile ''

execute import time

execute __cmd = '/vol/ek/assaff/workspace/peptalk/peptalk-%s.log rotate'

execute __IP.magic_logstart(__cmd % time.strftime('%Y-%m-%d'))
