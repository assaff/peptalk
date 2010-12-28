%% Find Cluster
display '--Find cluster for 2ZJD--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('2ZJD');

display '--DONE--'
