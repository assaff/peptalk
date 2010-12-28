%% Find Cluster
display '--Find cluster for 3D9T--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('3D9T');

display '--DONE--'
