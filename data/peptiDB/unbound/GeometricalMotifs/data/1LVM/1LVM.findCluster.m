%% Find Cluster
display '--Find cluster for 1LVM--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('1LVM');

display '--DONE--'
