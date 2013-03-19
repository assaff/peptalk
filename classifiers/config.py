
import joblib
import data
from treedict import TreeDict
from sklearn import svm

memory = joblib.Memory('cache')

@memory.cache
def createConfig(feature_set, title_meta=None):
    config = TreeDict('config')
    config.train_set.update(data.prepDataSet('bound.data.full.csv', features=feature_set, truncate=False))
    config.test_set.update(data.prepDataSet('unbound.data.full.csv', features=feature_set, truncate=False))
    
    config.title = config.train_set.feature_set.getTitle(metadata=title_meta)
    #display(Latex(config.title))
    return config

@memory.cache
def trainClassifier(conf):
    clf = svm.SVC(
            kernel='linear', 
            probability=True, 
            class_weight='auto',
            )
    return clf.fit(conf.train_set.X, conf.train_set.y)

@memory.cache
def trainConfigClassifiers(configs):
    clfs = {}
    for i, c in enumerate(configs):
        print "Fitting SVCs on feature set: %s" % c.title
        clfs[i] = trainClassifier(c) #c.svm.fit(c.train_set.X, c.train_set.y)
        
    return clfs

@memory.cache
def predictClassifier(conf):
    clf = trainClassifier(conf)
    return clf.predict_proba(conf.test_set.X)

