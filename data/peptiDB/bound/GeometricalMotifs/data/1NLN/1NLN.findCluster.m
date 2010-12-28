%% Find Cluster
display '--Find cluster for 1NLN--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('1NLN');

display '--DONE--'
