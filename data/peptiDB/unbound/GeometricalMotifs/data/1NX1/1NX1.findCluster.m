%% Find Cluster
display '--Find cluster for 1NX1--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('1NX1');

display '--DONE--'
