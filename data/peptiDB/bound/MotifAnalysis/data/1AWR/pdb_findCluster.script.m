%% Find Cluster
display '--Find cluster for PDBID_--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('PDBID_');
