%% Find Cluster
display '--Find cluster for 2PUY--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('2PUY');

display '--DONE--'
