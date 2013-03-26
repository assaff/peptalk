
import os, shutil, subprocess
import hashlib
from StringIO import StringIO
import joblib

import pandas as pd
import prody

prody.confProDy(verbosity='error')

fpocket_bin = '/home/assaff/tools/fpocket2/bin/fpocket'
fpocket_cache = '/home/assaff/data/fpocket/cache'

memory = joblib.Memory('cache')

#@memory.cache
def pocket_data(pdb_filename, 
            params_dict=dict(),#i=30, m=3.0, M=6.0, A=3, D=1.73, s=2.5, n=3, r=4.5),
            ):
    fpocket_cachedir = os.path.join(
                    fpocket_cache,
                    '-'.join('{}{}'.format(k, params_dict[k]) for k in sorted(params_dict.keys()) ),
                    #os.path.basename(os.path.dirname(pdb_filename)),
                    )
    if not os.path.isdir(fpocket_cachedir):
        os.makedirs(fpocket_cachedir)
        pass
    
    #print fpocket_cachedir
    
    cached_filename = os.path.join(fpocket_cachedir, 
                                   '{digest}-{filename}'.format(
                                        filename=os.path.basename(pdb_filename), 
                                        digest=hashlib.md5(open(pdb_filename).read()).hexdigest(),
                                        ),
                                    )
    #print cached_filename
    if not os.path.exists(cached_filename):
        shutil.copy2(pdb_filename, cached_filename)
    
    cached_filename_base = os.path.splitext(os.path.basename(cached_filename))[0]
    result_dirname = os.path.join(fpocket_cachedir, cached_filename_base+'_out')
    
    if not os.path.exists(result_dirname):
        print "calculating pockets for {fn}".format(fn=cached_filename)
        subprocess.Popen([fpocket_bin, '-f', cached_filename,] +
                         ['-{option} {value}'.format(option=k, value=v) for k,v in params_dict.items()],
                         ).communicate()
        
    #print os.listdir(result_dirname)
    
    desc_csv_filename = os.path.join(result_dirname, cached_filename_base + '_pockets.csv')
    pockets_table = pd.read_csv(desc_csv_filename, skiprows=1, )#index_col=[0])
    num_pockets = len(pockets_table)
    
    pockets_dirname = os.path.join(result_dirname, 'pockets')
    def get_pocket_atoms(num):
        pocket_atm_filename = os.path.join(pockets_dirname, 'pocket{num:02d}_vert.pdb'.format(num=num))
        assert os.path.isfile(pocket_atm_filename)
        return prody.parsePDB(pocket_atm_filename)
    
    pockets_table['Pocket atoms'] = pockets_table.reset_index().index.map(get_pocket_atoms)
    
    return pockets_table