
import sklearn
from treedict import TreeDict
import pandas as pd
import joblib

memory = joblib.Memory('cache')

class FeatureSet():
    
    def __init__(self, features, all_features):
        if isinstance(features, str):
            features = [features]
            
        self.features = list(features)
        self.all_features = list(all_features)
        
    @property
    def is_delta(self,):
        return float(len(self.features)) >= 0.5 * float(len(self.all_features))
    
    
    def getTitle(self, style='latex', metadata=None):
        features_in_title = self.features if not self.is_delta else set(self.all_features).difference(set(self.features))
        if metadata: features_in_title = [metadata,]
            
        def latexText(s):
            return r'\text{'+s+'}'
        
        if style == 'latex' or style=='text':
            if set(self.features) == set(self.all_features):
                return 'All features'
            
            separator = ' ' if self.is_delta else ' + '
            prefix = r'$\Delta$' if self.is_delta else r''
            return separator.join(prefix + f for f in features_in_title)
        
    def __repr__(self,):
        return self.getTitle(style='text')
    
@memory.cache
def prepDataSet(csv_filename, dataset_name='generic dataset', features=None, truncate=False):
    '''
    prepares a data set object from a CSV file, under the conventions of this project:
    - the CSV is indexed by PDBID and residue number (columns 0,1)
    - the last column contains label-related data, mostly ddG values of residues.
    - all other columns are feature columns.

    The function reads the columns into a TreeDict structure, such that each component
    (normalized feature data, labels, PDB identifiers, columns used) is accessible as 
    an attribute.

    ``dataset_name`` is optional, giving the TreeDict a name.
    Optional argument ``features`` directs the function which features to select from 
    the table. By default, all features are selected.
    '''
    
    dataset = TreeDict(dataset_name)
    dataset._df = pd.read_csv(csv_filename, index_col=[0,1], )
    
    if truncate:
        dataset._df = dataset._df[:DEBUG_DATASET_SIZE]
    
    all_feature_data_df = dataset._df.ix[:,:-1]
    
    all_features = all_feature_data_df.columns.tolist()
    selected_features = features if features else all_features
    dataset.feature_set = FeatureSet(selected_features, all_features)
    
    dataset.feature_data_df = all_feature_data_df.ix[:,dataset.feature_set.features]
    #dataset.X = dataset.feature_data_df.values 
    dataset.X = sklearn.preprocessing.scale(
                    dataset.feature_data_df.values)
    
    dataset.label_data_df = dataset._df.ix[:,-1]
    dataset.y = dataset.label_data_df.values > 1.0
    
    # sanity checks
    assert dataset.X.shape[0] == len(dataset.y)
    
    dataset.pdbs = dataset.feature_data_df.index.get_level_values(0)
    
    return dataset


