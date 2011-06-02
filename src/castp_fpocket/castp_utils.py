'''
Created on Jun 2, 2011

@author: assaff
'''

import sys
import StringIO

DEFAULT_FEATURE_FOR_RANKING = 'area_sa'

CASTP_POCKET_FEATURES= ['ID','N_mth','Area_sa','Area_ms','Vol_sa','Vol_ms','Lenth','cnr']

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

def get_all_pocket_stats(poc_info_file,):
    # get the CASTp pocket number of desired rank
    pockets = []
    for value_list in [line.split()[2:] for line in open(poc_info_file).readlines()[1:]]:
        pocket_entries = dict(zip(CASTP_POCKET_FEATURES, value_list))
        poc = Pocket(**pocket_entries)
        if poc.N_mth == 0: continue
        pockets.append(poc)
    return pockets

def get_pocket_pdb(poc_file_fd, poc_id):
    # a kind of grep over pocket number
    POC_ID_COLUMN_NUM = 11
    poc_lines = [line for line in poc_file_fd.readlines() if line.startswith('ATOM') and int(line.split()[POC_ID_COLUMN_NUM])==poc_id]
    pdb_result = StringIO.StringIO()
    pdb_result.writelines(poc_lines)
    pdb_str = pdb_result.getvalue()
    pdb_result.close()
    return pdb_str

def pocket_stats_str(poc):
    stats_fd = StringIO.StringIO()        
    stats_fd.writelines(['  %s     \t:\t%.3f\n' % (field, float(poc.__dict__[field]))
                              for field in CASTP_POCKET_FEATURES])
    stats_fd.flush()
    stats_str = stats_fd.getvalue()
    stats_fd.close()
    return stats_str

if __name__ == '__main__':
    poc_file = sys.argv[1]
    poc_info_file = sys.argv[2]
    rank = int(sys.argv[3])
    feature = DEFAULT_FEATURE_FOR_RANKING
    try:
        feature_arg = sys.argv[4]
        if feature_arg not in CASTP_POCKET_FEATURES:
                raise IOError('''feature %s is not a legitimate CASTp pocket feature.\nPlease provide one of the following: %s''' 
                              % (feature_arg, str(CASTP_POCKET_FEATURES)))
        feature = feature_arg
    except IndexError: pass
    
    sort_by_feature = lambda poc: poc.__dict__[feature]
    pockets = sorted(get_all_pocket_stats(poc_info_file), key=sort_by_feature, reverse=True)
    poc_file_fd = open(poc_file)
    for poc in pockets:
        poc.pdb_str = get_pocket_pdb(poc_file_fd, poc.ID)
    poc_file_fd.close()
    
    info_file = open('%s_info.castp.txt' % poc_file[:4], 'w')
    for poc in pockets:
        rank = pockets.index(poc)
        print >> info_file, 'Pocket %d:' % (rank)
        print >> info_file, pocket_stats_str(poc)
        pdb_filename = 'pocket%d_atm.castp.pdb' % rank
        pdb_file = open(pdb_filename, 'w')
        print >> pdb_file, poc.pdb_str
        pdb_file.close()
    info_file.close()