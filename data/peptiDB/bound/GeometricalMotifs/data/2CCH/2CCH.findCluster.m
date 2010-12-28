%% Find Cluster
display '--Find cluster for 2CCH--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('2CCH');

display '--DONE--'
