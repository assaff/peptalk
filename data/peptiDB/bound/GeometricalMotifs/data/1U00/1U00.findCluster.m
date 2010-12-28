%% Find Cluster
display '--Find cluster for 1U00--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('1U00');

display '--DONE--'
