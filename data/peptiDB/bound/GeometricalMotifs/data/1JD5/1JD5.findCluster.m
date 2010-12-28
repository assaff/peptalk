%% Find Cluster
display '--Find cluster for 1JD5--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('1JD5');

display '--DONE--'
