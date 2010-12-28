%% Find Cluster
display '--Find cluster for 1T4F--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('1T4F');

display '--DONE--'
