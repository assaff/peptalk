
import joblib
import data
from treedict import TreeDict
from sklearn import svm

memory = joblib.Memory('cache')

@memory.cache
def createConfig(feature_set, train='unbound', test='bound', title_meta=None):
    config = TreeDict('config')
    config.feature_set = feature_set
    config.bound.update(data.prepDataSet('bound.data.full.csv',
        config.feature_set, truncate=False))
    config.unbound.update(data.prepDataSet('unbound.data.full.csv',
        config.feature_set, truncate=False))

    config.training  = config.unbound if train=='unbound' else config.bound
    config.testing = config.bound if test=='bound' else config.unbound
    
    config.title = feature_set.getTitle()
    #display(Latex(config.title))
    return config

@memory.cache
def trainClassifier(conf):
    clf = svm.LinearSVC(
            class_weight='auto',
            dual=False,
            )
    return clf.fit(conf.training.X, conf.training.y)

@memory.cache
def trainConfigClassifiers(configs):
    clfs = {}
    for i, c in enumerate(configs):
        print "Fitting SVCs on feature set: %s" % c.title
        clfs[i] = trainClassifier(c) 
        
    return clfs

@memory.cache
def predictClassifier(conf):
    clf = trainClassifier(conf)
    return clf.decision_function(conf.testing.X)

