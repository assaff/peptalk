%% Find Cluster
display '--Find cluster for 2D0N--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('2D0N');

display '--DONE--'
