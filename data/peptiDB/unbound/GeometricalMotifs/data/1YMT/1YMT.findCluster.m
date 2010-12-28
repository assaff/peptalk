%% Find Cluster
display '--Find cluster for 1YMT--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('1YMT');

display '--DONE--'
