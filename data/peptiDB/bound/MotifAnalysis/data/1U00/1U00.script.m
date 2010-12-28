pathdef;

display 1U00
cov = load('1U00.mat.cov');
hb = load('1U00.mat.hb'); 

%interface = load('1U00.mat.interfaceRes'); 
%chainClass_temp = importdata('1U00.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1U00, statsWPeptide_1U00] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1U00, simpleStatsWPeptide_1U00] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1U00] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1U00];

clear cov hb

save 1U00_data;
display DONE_DATA

temp = full(minimalStats_1U00);
fid = fopen('minimalMotifs_1U00.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE