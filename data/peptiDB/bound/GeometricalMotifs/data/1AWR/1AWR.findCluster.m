%% Find Cluster
display '--Find cluster for 1AWR--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('1AWR');

display '--DONE--'
