pathdef;

display 1HC9
cov = load('1HC9.mat.cov');
hb = load('1HC9.mat.hb'); 

%interface = load('1HC9.mat.interfaceRes'); 
%chainClass_temp = importdata('1HC9.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1HC9, statsWPeptide_1HC9] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1HC9, simpleStatsWPeptide_1HC9] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1HC9] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1HC9];

clear cov hb

save 1HC9_data;
display DONE_DATA

temp = full(minimalStats_1HC9);
fid = fopen('minimalMotifs_1HC9.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE