# IPython log file

from sklearn.datasets import load_svmlight_file
x_train, y_train = load_svmlight_file('classifier2_ftmap/trainMat')
x_train
#[Out]# <5561x2 sparse matrix of type '<type 'numpy.float64'>'
#[Out]# 	with 11122 stored elements in Compressed Sparse Row format>
y_train
#[Out]# array([-1., -1., -1., ..., -1., -1., -1.])
len(_)
#[Out]# 5561
x_train, y_train = load_svmlight_file('classifier2_ftmap/testMat')
y_train
#[Out]# array([-1., -1., -1., ..., -1., -1., -1.])
len(_)
#[Out]# 6507
from sklearn import svm
x_train, y_train = load_svmlight_file('classifier2_ftmap/trainMat')
clf = svm.SVC()
clf.fit(x_train, y_train)
#[Out]# SVC(C=1.0, cache_size=200, class_weight=None, coef0=0.0, degree=3, gamma=0.0,
#[Out]#   kernel='rbf', probability=False, shrinking=True, tol=0.001,
#[Out]#   verbose=False)
slf
clf
#[Out]# SVC(C=1.0, cache_size=200, class_weight=None, coef0=0.0, degree=3, gamma=0.0,
#[Out]#   kernel='rbf', probability=False, shrinking=True, tol=0.001,
#[Out]#   verbose=False)
x_test, y_test = load_svmlight_file('classifier2_ftmap/testMat')
_y_test = clf.predict(x_test)
_y_test
#[Out]# array([-1., -1., -1., ..., -1., -1., -1.])
len(_y_test)
#[Out]# 6507
from sklearn import metrics
print metrics.classification_report(y_test, _y_test)
get_ipython().magic(u'logstart sklearn-svm-on-peptidb.py -o')
