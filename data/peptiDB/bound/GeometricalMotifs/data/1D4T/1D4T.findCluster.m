%% Find Cluster
display '--Find cluster for 1D4T--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('1D4T');

display '--DONE--'
