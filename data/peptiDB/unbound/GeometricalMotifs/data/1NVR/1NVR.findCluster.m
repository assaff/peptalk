%% Find Cluster
display '--Find cluster for 1NVR--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('1NVR');

display '--DONE--'
