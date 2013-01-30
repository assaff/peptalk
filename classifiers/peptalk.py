from sklearn.cluster import Ward, DBSCAN
from sklearn.neighbors import kneighbors_graph

import prody
prody.confProDy(verbosity='error')

import numpy as np
from matplotlib import pylab as pl

from collections import defaultdict

class PeptalkResult:
    
    SURFACE_RESIDUES_FILENAME_PATTERN = 'classifier1_full/SurfaceResidues/{pdb}.bound.res'
    DDG_RESIDUES_FILENAME_PATTERN = 'classifier1_full/BindingResidues_alaScan/{pdb}.res'
    BINDING_RESIDUES_FILENAME_PATTERN = 'classifier1_full/BindingResidues_cutoff_4A/{pdb}.res'
    PDB_FILENAME_PATTERN = '../data/peptiDB/bound/boundSet/{pdb}.pdb'
    
    WARD_N_CLUSTERS = 5
    
    def __init__(self, pdbid, preds=None):
        self.pdbid = pdbid.upper()
        
        self.pdb_filename = self.PDB_FILENAME_PATTERN.format(pdb=self.pdbid)
        self.atoms = prody.parsePDB(self.pdb_filename).noh
        
        surface_res_filename = self.SURFACE_RESIDUES_FILENAME_PATTERN.format(pdb=self.pdbid)
        self.surface_resnums = pl.loadtxt(surface_res_filename, usecols=[1], dtype=int)
        self.surface_resnums.sort()
        self.surface_residues = self.atoms.select('chain A and resnum %s' % ' '.join(map(str, self.surface_resnums)))
        
        ddg_res_filename = self.DDG_RESIDUES_FILENAME_PATTERN.format(pdb=self.pdbid)
        self.ddgs = defaultdict(float)
        for resnum, ddg in pl.loadtxt(ddg_res_filename, usecols=[1, 2], dtype=[('resnum', int), ('ddg', float)]):
            self.ddgs[resnum] = ddg
        self.ddg_resnums = sorted([resnum for resnum in self.ddgs if self.ddgs[resnum]>0])
            
        binders_filename = self.BINDING_RESIDUES_FILENAME_PATTERN.format(pdb=self.pdbid)
        self.binders_resnums = pl.loadtxt(binders_filename, usecols=[1], dtype=int)
            
        if preds is not None:
            assert len(preds) == len(self.surface_resnums)
            pos_sur_resnums = self.surface_resnums[preds != 0]
            self.positive_surface_residues = self.surface_residues.select('resnum %s' % ' '.join(map(str, pos_sur_resnums)))
            
        #print 'Surface residues:', self.surface_residues.getHierView().numResidues()
        #print 'Positive residues:', self.positive_surface_residues.getHierView().numResidues()
        #print 'Positive atoms:', len(self.positive_surface_residues.select('ca or sidechain'))
            
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

    @property
    def total_ddg(self,):
        return float(sum(self.ddgs.values()))

    @property
    def recovered_ddg(self,):
        ddg_residues_recovered = (
                    set(self.ddgs.keys()) &
                    set(list(self.positive_surface_residues.ca.getResnums()))
                    )
        return sum(self.ddgs[i] for i in ddg_residues_recovered)

    
    def cluster_ddg(self, cluster_resnums):
        #if len(ddg_residues_recovered)==0:
            #print ddg_residues_recovered
            #print self.ddgs.keys(),
            #print self.positive_surface_residues.ca.getResnums()

        cluster_ddg = sum(self.ddgs[i] for i in cluster_resnums)
        return cluster_ddg

    def cluster_ddg_recall(self, cluster_resnums):
        if self.recovered_ddg == 0:
            return 0, 0

        cluster_ddg = self.cluster_ddg(cluster_resnums)
    
        cluster_ddg_frac = float(cluster_ddg) / float(self.total_ddg)
        recovered_ddg_frac = float(self.recovered_ddg) / float(self.total_ddg)

        return (cluster_ddg_frac, 
                cluster_ddg_frac / recovered_ddg_frac)

    def cluster_recall_precision(self, cluster_resnums, binders_resnums):
        binders_resnums = set(binders_resnums)
        cluster_resnums = set(cluster_resnums)
        
        #print cluster_resnums
        #print binders_resnums
        
        relevant = float(len(binders_resnums))
        retrieved = float(len(cluster_resnums))
        relevant_and_retrieved = len(binders_resnums & cluster_resnums)
        
        cluster_recall = relevant_and_retrieved / relevant
        cluster_precision = relevant_and_retrieved / retrieved
        
        return cluster_recall, cluster_precision

