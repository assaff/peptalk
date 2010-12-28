%% Find Cluster
display '--Find cluster for 1IHJ--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('1IHJ');

display '--DONE--'
