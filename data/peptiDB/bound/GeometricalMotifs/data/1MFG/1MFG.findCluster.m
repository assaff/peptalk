%% Find Cluster
display '--Find cluster for 1MFG--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('1MFG');

display '--DONE--'
