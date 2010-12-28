%% Find Cluster
display '--Find cluster for 2VJ0--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('2VJ0');

display '--DONE--'
