pathdef;

display 1W9E
cov = load('1W9E.mat.cov');
hb = load('1W9E.mat.hb'); 

%interface = load('1W9E.mat.interfaceRes'); 
%chainClass_temp = importdata('1W9E.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1W9E, statsWPeptide_1W9E] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1W9E, simpleStatsWPeptide_1W9E] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1W9E] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1W9E];

clear cov hb

save 1W9E_data;
display DONE_DATA

temp = full(minimalStats_1W9E);
fid = fopen('minimalMotifs_1W9E.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE