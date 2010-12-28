pathdef;

display 2O9V
cov = load('2O9V.mat.cov');
hb = load('2O9V.mat.hb'); 

%interface = load('2O9V.mat.interfaceRes'); 
%chainClass_temp = importdata('2O9V.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2O9V, statsWPeptide_2O9V] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2O9V, simpleStatsWPeptide_2O9V] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2O9V] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2O9V];

clear cov hb

save 2O9V_data;
display DONE_DATA

temp = full(minimalStats_2O9V);
fid = fopen('minimalMotifs_2O9V.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE