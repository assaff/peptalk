from sklearn.cluster import Ward, DBSCAN
from sklearn.neighbors import kneighbors_graph
from sklearn import svm, cross_validation, preprocessing, datasets, metrics

import prody
prody.confProDy(verbosity='error')

import numpy as np
import pandas as pd
from matplotlib import pylab as pl

from collections import defaultdict

import config

unbound_data = pd.read_csv('bound.data.old.csv', index_col=[0,1])

BOUND_FILENAME_PATTERN = '../data/peptiDB/bound/boundSet/mainChain/{pdb}.pdb'
UNBOUND_FILENAME_PATTERN = '../data/peptiDB/unbound/unboundSet/{pdb}.pdb'

class Classifier:
    """
    Defines a SVM classifier.
    """

    def __init__(self, pdbid, cfg, ):
        self.pdbid = pdbid

        self.config = cfg
        self.svm = config.trainClassifier(self.config)

        fn_pattern = BOUND_FILENAME_PATTERN if self.config.testing.is_bound \
                else UNBOUND_FILENAME_PATTERN
        self.pdb_filename = fn_pattern.format(pdb=self.pdbid)
        self.receptor = prody.parsePDB(self.pdb_filename).protein.noh

        self.ddgs = self.config.testing.label_data_df.ix[self.pdbid]
        self.confidence = pd.Series(
                data=config.predictClassifier(self.config),
                index=self.config.testing.label_data_df.index,
                ).ix[self.pdbid]

        self.mask_binding = self.ddgs > self.config.testing.ddg_cutoff
        self.mask_positive = self.confidence > 0

        self.surface_resnums = self.ddgs.index
        self.binding_resnums = \
                self.surface_resnums[self.mask_binding]
        self.positive_resnums = \
                self.surface_resnums[self.mask_positive]

        def receptor_residues(resnums):
            return self.receptor.select(
                    'resnum %s' % ' '.join(map(str, resnums)))

        self.surface_residues = receptor_residues(self.surface_resnums)
        self.positive_residues = receptor_residues(self.positive_resnums)

    def conf_sum(self, resnums):
        return self.confidence[resnums].sum()

    def cluster_naive(self, k=10):
        positive_confs = self.confidence[self.confidence > 0]
        ranks = positive_confs.rank(
                method='first', ascending=False) - 1
        clusters = positive_confs.groupby(
                lambda resnum: int(ranks[resnum]) / k)
        return dict((k, v.index) for k, v in clusters)

    def cluster_dbscan(self, calpha=False, cluster_diameter=6, cluster_min_size=10):
        '''
        cluster the residues using the DBSCAN method. 
        The parameters here are neighborhood diameter (eps) and neighborhood 
        connectivity (min_samples).
        
        Returns a list of cluster labels, in which label ``-1`` means an outlier point,
        which doesn't belong to any cluster.
        '''

        if not self.positive_residues:
            return {}
        
        if calpha:
            data_atoms = self.positive_residues.select('ca')
        else:
            data_atoms = self.positive_residues.select('sidechain or ca').copy()
        
        assert (
                data_atoms.getHierView().numResidues() == 
                self.positive_residues.getHierView().numResidues()
                )
        
        OUTLIER_LABEL = -1
        
        db_clust = DBSCAN(eps=cluster_diameter, min_samples=cluster_min_size)
        db_clust.fit(data_atoms.getCoords())

        db_labels = db_clust.labels_.astype(int)
        #print db_labels, len(db_labels)
        if calpha:
            residue_labels = db_labels
        
        else:
            residues = list(data_atoms.getHierView().iterResidues())
            residue_labels = np.zeros(len(residues), dtype=int)
            
            def most_common(lst):
                lst = list(lst)
                return max(set(lst) or [OUTLIER_LABEL], key=lst.count)
            
            data_atoms.setBetas(db_labels)
            for i, res in enumerate(residues):
                atom_labels = res.getBetas()
                residue_labels[i] = most_common(atom_labels[atom_labels!=OUTLIER_LABEL])
                
        assert len(residue_labels) == self.positive_residues.getHierView().numResidues()
        
        residue_numbers = self.positive_residues.ca.getResnums()
        clusters = sorted(
                [residue_numbers[residue_labels==i] for i in
                    set(residue_labels) if i!=-1], 
                key=self.conf_sum, 
                reverse=True,
                )
        return dict(enumerate(clusters))

    def cluster_ward(self, calpha=True, num_clusters=5):
        '''
        cluster the positively predicted residues using the Ward method.
        Returns a list of cluster labels the same length as the number of positively predicted residues.
        '''
        
        if calpha:
            data_atoms = self.positive_residues.ca
        else:
            data_atoms = self.positive_residues.select('ca or sidechain').copy()
        #if data_atoms.getCoords().shape[0] < 4:
            #print self.pdbid, data_atoms.getCoords().shape
            #return {}
        connectivity = kneighbors_graph(data_atoms.getCoords(), 5)
        ward = Ward(n_clusters=num_clusters, connectivity=connectivity)
        ward.fit(data_atoms.getCoords())
        resnums = data_atoms.getResnums()
        reslabels = ward.labels_
        clusters = sorted([resnums[reslabels==i] for i in set(reslabels)], 
                key=len, reverse=True)
        return dict(enumerate(clusters))

    def cluster_accuracy(self, resnums):
        cluster_mask = self.surface_resnums.map(
                lambda resnum: resnum in resnums)
        ddg_mask = self.ddgs > self.config.testing.ddg_cutoff
        return metrics.accuracy_score(ddg_mask, cluster_mask)

    @property
    def total_ddg(self,):
        return self.ddgs.sum()

    @property
    def recovered_ddg(self,):
        return self.ddgs[self.positive_resnums].sum()

    def cluster_ddg(self, cluster_resnums):
        return self.ddgs[cluster_resnums].sum()

    def cluster_ddg_recall(self, cluster_resnums):
        if self.recovered_ddg == 0:
            return 0, 0

        cluster_ddg = self.cluster_ddg(cluster_resnums)
    
        cluster_ddg_frac = float(cluster_ddg) / float(self.total_ddg)
        recovered_ddg_frac = float(self.recovered_ddg) / float(self.total_ddg)

        return (cluster_ddg_frac, 
                cluster_ddg_frac / recovered_ddg_frac)

    def cluster_recall_precision(self, cluster_resnums):
        binders_resnums = set(self.binding_resnums)
        cluster_resnums = set(cluster_resnums)
        
        if len(cluster_resnums):
            return 0, 0
        relevant = float(len(binders_resnums))
        if relevant == 0:
            return 0, 0
        retrieved = float(len(cluster_resnums))
        relevant_and_retrieved = len(binders_resnums & cluster_resnums)
        
        cluster_recall = relevant_and_retrieved / relevant
        cluster_precision = relevant_and_retrieved / retrieved
        
        return cluster_recall, cluster_precision




class PeptalkResult:
    
    #SURFACE_RESIDUES_FILENAME_PATTERN = 'classifier1_full/SurfaceResidues/{pdb}.bound.res'
    #DDG_RESIDUES_FILENAME_PATTERN = 'classifier1_full/BindingResidues_alaScan/{pdb}.res'
    #BINDING_RESIDUES_FILENAME_PATTERN = 'classifier1_full/BindingResidues_cutoff_4A/{pdb}.res'
    PDB_FILENAME_PATTERN = '../data/peptiDB/bound/boundSet/mainChain/{pdb}.pdb'
    
    WARD_N_CLUSTERS = 5
    
    def __init__(self, pdbid, preds=None, confidence=None):
        self.pdbid = pdbid.upper()
        
        self.pdb_filename = self.PDB_FILENAME_PATTERN.format(pdb=self.pdbid)
        self.atoms = prody.parsePDB(self.pdb_filename).noh

        self.svm_data = unbound_data.ix[self.pdbid]
        
        #surface_res_filename = self.SURFACE_RESIDUES_FILENAME_PATTERN.format(pdb=self.pdbid)
        #self.surface_resnums = pl.loadtxt(surface_res_filename, usecols=[1], dtype=int)
        self.surface_resnums = self.svm_data.index.get_level_values(1).values
        self.surface_resnums.sort()
        self.surface_residues = self.atoms.select('resnum %s' % ' '.join(map(str, self.surface_resnums)))
        
        #ddg_res_filename = self.DDG_RESIDUES_FILENAME_PATTERN.format(pdb=self.pdbid)
        #self.ddgs = defaultdict(float)
        #for resnum, ddg in self.svm_data[:,-1].to_dict().items():
            #self.ddgs[resnum] = ddg
        self.ddgs = self.svm_data.ix[:, -1]#.to_dict()
        self.ddg_resnums = self.svm_data.ix[self.ddgs > 0].index
            
        #binders_filename = self.BINDING_RESIDUES_FILENAME_PATTERN.format(pdb=self.pdbid)
        #self.binders_resnums = pl.loadtxt(binders_filename, usecols=[1], dtype=int)
            
        if preds is not None:
            assert len(preds) == len(self.surface_resnums), \
            '{}!={}'.format(len(preds), len(self.surface_resnums))
            pos_sur_resnums = self.surface_resnums[preds != 0]
            self.positive_residues = (self.surface_residues.select(
                    'resnum %s' % ' '.join(map(str, pos_sur_resnums))) 
                    if len(pos_sur_resnums)>0 else None)

            if confidence is not None:
                assert len(confidence) == len(self.surface_resnums)
                self.confidence = defaultdict(float)
                for resnum, c in zip(self.surface_resnums, confidence):
                    self.confidence[resnum] = c
            
        #print 'Surface residues:', self.surface_residues.getHierView().numResidues()
        #print 'Positive residues:', self.positive_residues.getHierView().numResidues()
        #print 'Positive atoms:', len(self.positive_residues.select('ca or sidechain'))

    def cluster_atoms(self, resnums):
        residues = self.atoms.select('resnum {rn}'.format(
            rn=' '.join(map(str, resnums))
            ))
        if residues:
            return residues.copy()
        return None

    def cluster_naive(self, k=5): 
        conf = pd.Series(self.confidence).order(ascending=False)
        conf = conf[conf > 0]
        ranks = conf.rank(method='first', ascending=False) - 1
        clusters = conf.groupby(lambda resnum: int(ranks[resnum]) / k)
        return dict((k, v.index) for k, v in clusters)
        #return dict(enumerate([conf.head((i+1)*k).tail(k).index#ix[i*k : (i+1)*k].index
            #for i in range(3) if len(conf) > (i+1)*k]))
            
    def cluster_ward(self, calpha=True):
        '''
        cluster the positively predicted residues using the Ward method.
        Returns a list of cluster labels the same length as the number of positively predicted residues.
        '''
        
        if calpha:
            data_atoms = self.positive_surface_residues.ca
        #else:
        #    data_atoms = self.positive_surface_residues.select('ca or sidechain').copy()
        if data_atoms.getCoords().shape[0] < 4:
            print self.pdbid, data_atoms.getCoords().shape
            return {}
        connectivity = kneighbors_graph(data_atoms.getCoords(), 5)
        ward = Ward(n_clusters=self.WARD_N_CLUSTERS, connectivity=connectivity)
        ward.fit(data_atoms.getCoords())
        resnums = data_atoms.getResnums()
        reslabels = ward.labels_
        clusters = sorted([resnums[reslabels==i] for i in set(reslabels)], key=len, reverse=True)
        return dict(enumerate(clusters))
    
    def cluster_dbscan(self, calpha=False, cluster_diameter=6, cluster_min_size=10):
        '''
        cluster the residues using the DBSCAN method. 
        The parameters here are neighborhood diameter (eps) and neighborhood 
        connectivity (min_samples).
        
        Returns a list of cluster labels, in which label ``-1`` means an outlier point,
        which doesn't belong to any cluster.
        '''

        if not self.positive_surface_residues:
            return {}
        
        if calpha:
            data_atoms = self.positive_surface_residues.select('ca')
        else:
            data_atoms = self.positive_surface_residues.select('sidechain or ca').copy()
        
        assert (
                data_atoms.getHierView().numResidues() == 
                self.positive_surface_residues.getHierView().numResidues()
                )
        
        OUTLIER_LABEL = -1
        
        db_clust = DBSCAN(eps=cluster_diameter, min_samples=cluster_min_size)
        db_clust.fit(data_atoms.getCoords())

        db_labels = db_clust.labels_.astype(int)
        #print db_labels, len(db_labels)
        if calpha:
            residue_labels = db_labels
        
        else:
            residues = list(data_atoms.getHierView().iterResidues())
            residue_labels = np.zeros(len(residues), dtype=int)
            
            def most_common(lst):
                lst = list(lst)
                return max(set(lst) or [OUTLIER_LABEL], key=lst.count)
            
            data_atoms.setBetas(db_labels)
            for i, res in enumerate(residues):
                atom_labels = res.getBetas()
                residue_labels[i] = most_common(atom_labels[atom_labels!=OUTLIER_LABEL])
                
        assert len(residue_labels) == self.positive_surface_residues.getHierView().numResidues()
        
        residue_numbers = self.positive_surface_residues.ca.getResnums()
        clusters = sorted([residue_numbers[residue_labels==i] for i in set(residue_labels) if i!=-1], key=len, reverse=True)
        return dict(enumerate(clusters))

    class Cluster(object):

        def __init__(self, receptor_result, resnums):
            self.parent = receptor_result
            self.resnums = resnums

        @property
        def ddgs(self,):
            return { rn: self.parent.ddgs[rn] for rn in self.resnums}

