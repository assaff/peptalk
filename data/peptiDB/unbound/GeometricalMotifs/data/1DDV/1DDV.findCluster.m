%% Find Cluster
display '--Find cluster for 1DDV--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('1DDV');

display '--DONE--'
