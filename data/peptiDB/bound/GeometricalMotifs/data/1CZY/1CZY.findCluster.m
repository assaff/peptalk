%% Find Cluster
display '--Find cluster for 1CZY--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('1CZY');

display '--DONE--'
