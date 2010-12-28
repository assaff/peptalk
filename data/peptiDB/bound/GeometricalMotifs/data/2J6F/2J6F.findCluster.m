%% Find Cluster
display '--Find cluster for 2J6F--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('2J6F');

display '--DONE--'
