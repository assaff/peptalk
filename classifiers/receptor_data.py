
import pandas as pd
import numpy as np
import prody
prody.confProDy(verbosity='error')
from sklearn import preprocessing

import subprocess
import tempfile
import os, sys, shutil
import string, re

from collections import OrderedDict
import itertools

import joblib
memory = joblib.Memory('cache')

import naccess
import fpocket

j = os.path.join
PROJECT_PATH = '/home/assaff/projects/peptalk'

DATA_PATH = j(PROJECT_PATH, 'data')
PEPTIDB_DATA_PATH = j(DATA_PATH, 'peptiDB')

class ReceptorData:
    
    def __init__(self, pdbid, context='bound'):
        self.pdbid = pdbid.upper()
        self.context = context
        bound = True if context=='bound' else False
        
        self.DATA_PATH = j(PEPTIDB_DATA_PATH, self.context)
        self.PDB_DATA_PATH = j(self.DATA_PATH, self.context+'Set', 'mainChain' if bound else '')
        self.FTMAP_DATA_PATH = j(self.DATA_PATH, 'FTMapAnalysis', 'ftmapData')
        self.CONSURF_DATA_PATH = j(self.DATA_PATH, 'ConSurfAnalysis', 'data')
        
        self.receptor_filename = j(self.PDB_DATA_PATH, '%s.pdb' % self.pdbid)
        self.receptor_atoms = prody.parsePDB(self.receptor_filename).protein
        
        self.receptor_chain = self.receptor_atoms.getHierView().iterChains().next()
        #print "###%s###" % self.receptor_filename
        self.resnum_index = pd.MultiIndex.from_tuples(
                            zip(
                                [pdbid]*self.receptor_chain.numResidues(),
                                self.receptor_chain.ca.getResnums()
                            ), 
                                names = [
                                    'PDB identifier', 
                                    'Residue number',
                                        ]
                                )
        self.df = pd.DataFrame(index=self.resnum_index)
        print self.pdbid
        
    def conservation(self,):
        consurf_pdb_filename = os.path.join(self.CONSURF_DATA_PATH, self.pdbid, 'pdbFILE_view_ConSurf.pdb')
        p = prody.parsePDB(consurf_pdb_filename)
        consurf_chain = p.getHierView().iterChains().next()
        return pd.DataFrame(
                            columns=['Conservation-score'],
                            index=self.resnum_index,
                            data=consurf_chain.ca.getBetas()[:len(self.resnum_index)],
                            )
    
    def sasa(self,):
        rsa = naccess.getResidueSasa(self.receptor_atoms)
        return pd.DataFrame(
                            rsa.values, 
                            index=self.resnum_index,
                            columns=rsa.columns, 
                            )
    
    def ftmap(self,):
        ######
        # calculate consensus clusters (ccls) statistics, independent of specific residues:
        ftmap_atoms = prody.parsePDB(j(self.FTMAP_DATA_PATH, '{}.map.clean.pdb'.format(self.pdbid)))
        
        ccls = pd.DataFrame(
                            list(ftmap_atoms.getHierView().iterChains()), 
                            #index=range(h.numChains()),
                            columns=['chain'],
                            )
        
        ccls['cs_size'] = ccls.chain.map(lambda chain: chain.numResidues())
        
        ccls['cs_rank'] = ccls.cs_size.rank(ascending=False, method='first')
        DUMMY_CCL_RANK = 15 #ccls.cs_rank.max()+1
        
        ######
        def nearby_ccls(resnum, cutoff=4.5):
            res = self.receptor_chain.getResidue(resnum)
            res_contacts = prody.Contacts(res.noh.getCoords())
            is_near_res = lambda ccl: res_contacts.select(cutoff, ccl) is not None
                            #ag.select('same chain as within {} of res'.format(float(cutoff)), 
                            #                res=res) is not None
            
            return ccls[ccls.chain.map(is_near_res)].cs_rank.tolist()
        
        def nearby_ccl(resnum, cutoff=4.5):
            ccls_near_ranks = nearby_ccls(resnum, cutoff)
            return ccls_near_ranks[0] if ccls_near_ranks else DUMMY_CCL_RANK#np.nan
        
        def num_nearby_ccls(resnum):
            return len(nearby_ccls(resnum))
        
        ind = pd.Index(self.receptor_chain.ca.getResnums())
        
        res_ccl_map = pd.DataFrame(
                    columns=['resnum','cs_rank', 'num_nearby_cs'], 
                    data=zip(
                        ind.tolist(), 
                        map(nearby_ccl, ind),
                        map(num_nearby_ccls, ind),
                        ),
                    )
        
        ccls = ccls.append({'chain': None, 'cs_size': 1, 'cs_rank': DUMMY_CCL_RANK}, ignore_index=True)
        
        ccls['cs_normalized_rank'] = ccls.cs_rank / ccls.cs_size
        
        ccls['cs_svm_size'] = np.minimum(
                                    np.ceil(ccls.cs_size / float(5)),
                                    4
                                    )
        ccls['cs_svm_rank'] = np.minimum(ccls.cs_rank, 5)
        
        ccls['cs_svm_norm_rank'] = ccls['cs_svm_rank'] / ccls['cs_svm_size'].astype(float)
        
        
        res_ccl_stats = res_ccl_map.merge(
                        ccls.drop(['chain'], axis=1), 
                        how='inner', 
                        on='cs_rank',
                            ).set_index('resnum')
        return res_ccl_stats.reindex(index=self.resnum_index, level=1)
    
    def pockets(self,):
        pocket_data = fpocket.pocket_data(self.receptor_filename)
        DUMMY_POCKET_RANK = 15#pocket_data['Pocket rank'].max()+1
        
        def nearby_pocket(resnum, cutoff=4.5):
            
            res = self.receptor_chain.getResidue(resnum)
        
            res_contacts = prody.Contacts(res.noh.getCoords())
            is_near_res = lambda pocket_atoms: res_contacts.select(cutoff, pocket_atoms) is not None
        
            pockets_near_rank = pocket_data.ix[
                            pocket_data['Pocket atoms'].map(is_near_res), 
                            'Pocket rank'
                                ].tolist()
            return pockets_near_rank[0] if pockets_near_rank else DUMMY_POCKET_RANK# np.nan
            
        res_pocket_map = pd.DataFrame(
                              columns = ['resnum', 'Pocket rank'],
                              index=self.resnum_index,
                              data=[(resnum, nearby_pocket(resnum)) for resnum 
                                    in self.resnum_index.get_level_values(1)],
                              )
        pocket_data = pocket_data.append({colname: DUMMY_POCKET_RANK if colname=='Pocket rank' else 0 
                            for colname in pocket_data.columns}, 
                                ignore_index=True,)
        
        res_pocket_stats = res_pocket_map.merge(
                            pocket_data.drop(['Pocket atoms'], axis=1), 
                            how='inner', 
                            on='Pocket rank', 
                                ).set_index('resnum')
        
        return res_pocket_stats.reindex(res_pocket_map.index, level=1)
    
    def aa_props(self,):
        aa_props = pd.read_csv('aa_props.csv', true_values='X', false_values='-',)
        aa_props['resname'] = [s.upper() for s in aa_props['Abbrev.']]
        
        aa_props['pKa'] = [float(n) for n in aa_props['pKa'].replace('-', '0.0')]
        aa_props = aa_props.replace('-', 'None')
        aa_props = aa_props.ix[:, 'Hydrophobic':]
        
        res_aa_map = pd.DataFrame(
                              columns=['resnum', 'resname'],
                              index=self.resnum_index,
                              data=[(resnum, self.receptor_chain.getResidue(resnum).getResname())
                                    for resnum in self.resnum_index.get_level_values(1)],
                            )
        res_aa_stats = res_aa_map.merge(aa_props, how='inner', on='resname',).set_index('resnum')
        return res_aa_stats.reindex(res_aa_map.index, level=1).drop(['resname'], axis=1)
            
    #@property
    def data(self,):
        if not hasattr(self, '_data'):
            feature_generators = OrderedDict(
                                         NAccess=self.sasa(),
                                         ConSurf=self.conservation(),
                                         FTMap=self.ftmap(),
                                         FPocket=self.pockets(),
                                         Physico=self.aa_props(),
                                         )
            
            tuples = list(itertools.chain(*[
                         [(prot_name, col_name) for col_name in prot_df.columns.tolist()]
                         for prot_name, prot_df in feature_generators.items()
                     ]))
            idex = pd.MultiIndex.from_tuples(tuples)
            
            self._data = pd.concat(feature_generators.values(), axis=1, keys=feature_generators.keys())
        return self._data
        
@memory.cache
def recdata(pdbid, context='bound'):
    return ReceptorData(pdbid, context).data()
