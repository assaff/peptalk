%% Find Cluster
display '--Find cluster for 2FMF--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('2FMF');

display '--DONE--'
