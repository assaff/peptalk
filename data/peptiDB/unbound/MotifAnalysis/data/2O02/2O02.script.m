pathdef;

display 2O02
cov = load('2O02.mat.cov');
hb = load('2O02.mat.hb'); 

%interface = load('2O02.mat.interfaceRes'); 
%chainClass_temp = importdata('2O02.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2O02, statsWPeptide_2O02] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2O02, simpleStatsWPeptide_2O02] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2O02] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2O02];

clear cov hb

save 2O02_data;
display DONE_DATA

temp = full(minimalStats_2O02);
fid = fopen('minimalMotifs_2O02.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE