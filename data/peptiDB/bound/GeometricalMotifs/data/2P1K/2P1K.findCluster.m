%% Find Cluster
display '--Find cluster for 2P1K--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('2P1K');

display '--DONE--'
