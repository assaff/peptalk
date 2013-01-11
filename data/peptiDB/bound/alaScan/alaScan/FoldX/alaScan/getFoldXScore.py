# IPython log file

fdxfn = 'ComplexAlaScan_1AWR.fxout'
rows = [row.split('\t') for row in 
            open(fdxfn).readlines()[22:]]
res_rows = [(int(row[0].split()[0][3:]), float(row[2])) 
            for row in rows]
res_rows
get_ipython().system(u'cat $fdxfn')
import itertools
list([res_rows[0]] + itertools.takewhile(lambda row: row[0] - res_rows[res_rows.index(row)-1][0] > 0, res_rows[1:]))
[res_rows[0]] + list(itertools.takewhile(lambda row: row[0] - res_rows[res_rows.index(row)-1][0] > 0, res_rows[1:]))
res_rows
get_ipython().magic(u'logstart getFoldXScore.py')
rows = [row.split('\t') for row in 
            open(fdxfn).readlines()[22:]]
res_rows = [(int(row[0].split()[0][3:]), float(row[2])) 
            for row in rows]
rec_rows = [res_rows[0]] + list(itertools.takewhile(lambda row: row[0] - res_rows[res_rows.index(row)-1][0] > 0, res_rows[1:]))
rec_rows
get_ipython().system(u'less ../../../../../../../classifiers/residue-svm-scores-labeled.csv')
rec_rows
fdxfn
get_ipython().system(u'less ../../../../../../../classifiers/residue-svm-scores-labeled.csv')
grep ../../../../../../../classifiers/residue-svm-scores-labeled.csv
get_ipython().system(u'grep 1AWR ../../../../../../../classifiers/residue-svm-scores-labeled.csv')
