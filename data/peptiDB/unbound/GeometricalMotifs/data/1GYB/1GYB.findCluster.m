%% Find Cluster
display '--Find cluster for 1GYB--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('1GYB');

display '--DONE--'
