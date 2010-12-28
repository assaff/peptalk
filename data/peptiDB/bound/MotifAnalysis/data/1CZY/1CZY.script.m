pathdef;

display 1CZY
cov = load('1CZY.mat.cov');
hb = load('1CZY.mat.hb'); 

%interface = load('1CZY.mat.interfaceRes'); 
%chainClass_temp = importdata('1CZY.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1CZY, statsWPeptide_1CZY] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1CZY, simpleStatsWPeptide_1CZY] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1CZY] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1CZY];

clear cov hb

save 1CZY_data;
display DONE_DATA

temp = full(minimalStats_1CZY);
fid = fopen('minimalMotifs_1CZY.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE