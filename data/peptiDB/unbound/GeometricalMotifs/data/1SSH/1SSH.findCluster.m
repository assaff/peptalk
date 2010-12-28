%% Find Cluster
display '--Find cluster for 1SSH--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('1SSH');

display '--DONE--'
