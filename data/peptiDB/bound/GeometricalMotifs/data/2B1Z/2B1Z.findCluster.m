%% Find Cluster
display '--Find cluster for 2B1Z--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('2B1Z');

display '--DONE--'
