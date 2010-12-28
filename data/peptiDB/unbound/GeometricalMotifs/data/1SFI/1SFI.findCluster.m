%% Find Cluster
display '--Find cluster for 1SFI--'
addpath(genpath('/vol/ek/dattias/PeptideDocking/bin/matlabScripts'));
pathdef;

findClosestCluster('1SFI');

display '--DONE--'
