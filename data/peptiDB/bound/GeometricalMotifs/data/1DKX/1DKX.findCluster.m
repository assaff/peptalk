%% Find Cluster
display '--Find cluster for 1DKX--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('1DKX');

display '--DONE--'
