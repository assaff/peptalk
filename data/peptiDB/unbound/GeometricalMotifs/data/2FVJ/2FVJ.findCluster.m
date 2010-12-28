%% Find Cluster
display '--Find cluster for 2FVJ--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('2FVJ');

display '--DONE--'
