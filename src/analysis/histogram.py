#!/usr/bin/python

import sys
import numpy as np
from scipy.stats.stats import histogram
import matplotlib.pyplot as plt
#import matplotlib.mlab as mlab

filenames=sys.argv[1:-1]
col_num=int(sys.argv[-1])-1

stats_mat = [] #np.ndarray((len(filenames),1))
for filename in filenames:
    lines = [line.strip().split() for line in open(filename).readlines() if not line.startswith('#')]
    stats_arr = [float(line[col_num]) for line in lines]
    stats_mat += [stats_arr]

stats_mat = np.array(stats_mat)
#epsilon=np.power(10,-3)
#(freqs, min_value, bin_size, outliers)=histogram(stats_arr, numbins=20, defaultlimits=[0, 1+epsilon])

#print '# '+'\t'.join(['BIN','BIN_MIN','BIN_FREQ'])
#for i in range(len(freqs)):
#    print '%.3f' % freqs[i]

#if sys.argv[3] is None: # or sys.argv[3]!='histogram':
#    exit()


fig = plt.figure()
ax = fig.add_subplot(111)
ax.set_alpha(0)

# the histogram of the data
#for stats_arr in np.split(stats_mat, stats_mat.shape[0]):
n, bins, patches = ax.hist(stats_mat.transpose(), 20, alpha=0.8,normed=False, , label=filenames)

ax.set_xlabel(raw_input('xlabel: '))
ax.set_ylabel(raw_input('ylabel: '))
ax.set_title(raw_input('title: '))
ax.legend()
ax.grid(True)

plt.show()

tosave=raw_input('wanna save the figure? ')
if tosave not in ['Y', 'y', 'yes']:
    exit()

savefilename=raw_input('file name: ')
pngfile = open(savefilename, 'w')
fig.savefig(pngfile, transparent=True, dpi=600, )
pngfile.close()

