%% Find Cluster
display '--Find cluster for 2QOS--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('2QOS');

display '--DONE--'
