pathdef;

display 1YWO
cov = load('1YWO.mat.cov');
hb = load('1YWO.mat.hb'); 

%interface = load('1YWO.mat.interfaceRes'); 
%chainClass_temp = importdata('1YWO.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1YWO, statsWPeptide_1YWO] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1YWO, simpleStatsWPeptide_1YWO] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1YWO] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1YWO];

clear cov hb

save 1YWO_data;
display DONE_DATA

temp = full(minimalStats_1YWO);
fid = fopen('minimalMotifs_1YWO.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE