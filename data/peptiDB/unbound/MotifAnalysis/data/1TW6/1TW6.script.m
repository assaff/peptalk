pathdef;

display 1TW6
cov = load('1TW6.mat.cov');
hb = load('1TW6.mat.hb'); 

%interface = load('1TW6.mat.interfaceRes'); 
%chainClass_temp = importdata('1TW6.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1TW6, statsWPeptide_1TW6] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1TW6, simpleStatsWPeptide_1TW6] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1TW6] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1TW6];

clear cov hb

save 1TW6_data;
display DONE_DATA

temp = full(minimalStats_1TW6);
fid = fopen('minimalMotifs_1TW6.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE