
import joblib
import data
from treedict import TreeDict
from sklearn import svm

memory = joblib.Memory('cache')

#@memory.cache
def createConfig(feature_set, train=None, test=None, title_meta=None,
        ddg_cutoff=0.0):
    config = TreeDict('config')
    config.feature_set = feature_set
    config.bound = 'bound.data.old.csv'
    config.unbound = 'unbound.data.old.csv'
    config.ddg_cutoff = ddg_cutoff

    config.training = data.prepDataSet(train or config.unbound,
            feature_set=config.feature_set, ddg_cutoff=ddg_cutoff)
    config.testing = data.prepDataSet(test or config.bound, 
            feature_set=config.feature_set, ddg_cutoff=ddg_cutoff)
    
    config.title = feature_set.getTitle()
    #display(Latex(config.title))
    return config

#@memory.cache
def trainClassifier(conf):
    clf = svm.LinearSVC(
            class_weight='auto',
            dual=True,
            loss='l1',
            )
    return clf.fit(conf.training.X, conf.training.y)

#@memory.cache
def trainConfigClassifiers(configs):
    clfs = {}
    for i, c in enumerate(configs):
        print "Fitting SVCs on feature set: %s" % c.title
        clfs[i] = trainClassifier(c) 
        
    return clfs

#@memory.cache
def predictClassifier(conf):
    clf = trainClassifier(conf)
    return clf.decision_function(conf.testing.X)

