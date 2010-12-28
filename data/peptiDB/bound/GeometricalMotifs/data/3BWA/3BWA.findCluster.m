%% Find Cluster
display '--Find cluster for 3BWA--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('3BWA');

display '--DONE--'
