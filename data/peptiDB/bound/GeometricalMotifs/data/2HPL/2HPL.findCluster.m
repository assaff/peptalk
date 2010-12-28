%% Find Cluster
display '--Find cluster for 2HPL--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('2HPL');

display '--DONE--'
