%% Find Cluster
display '--Find cluster for 1UJ0--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('1UJ0');

display '--DONE--'
