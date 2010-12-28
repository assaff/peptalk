%% Find Cluster
display '--Find cluster for 1T7R--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('1T7R');

display '--DONE--'
