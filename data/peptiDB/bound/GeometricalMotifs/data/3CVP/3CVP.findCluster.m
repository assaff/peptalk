%% Find Cluster
display '--Find cluster for 3CVP--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('3CVP');

display '--DONE--'
