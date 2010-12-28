%% Find Cluster
display '--Find cluster for 1HC9--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('1HC9');

display '--DONE--'
