%% Find Cluster
display '--Find cluster for 1YWO--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('1YWO');

display '--DONE--'
