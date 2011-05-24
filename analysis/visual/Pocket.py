class Pocket:
    def __init__(self, **entries):
        for k,v in entries.items():
            try: 
                try:
                    entries[k] = int(v)
                except:
                    entries[k] = float(v)
            except: pass
        self.__dict__.update(entries)
    
    def __repr__(self): 
        return '<%s>' % str('\n '.join('%s : %s' % (k, repr(v)) for (k, v) in self.__dict__.iteritems()))
