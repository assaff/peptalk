%% Find Cluster
display '--Find cluster for 1RXZ--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('1RXZ');

display '--DONE--'
