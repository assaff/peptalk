%% Find Cluster
display '--Find cluster for 3BU3--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('3BU3');

display '--DONE--'
