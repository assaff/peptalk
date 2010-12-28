%% Find Cluster
display '--Find cluster for 2JAM--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('2JAM');

display '--DONE--'
