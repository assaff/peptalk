pathdef;

display 1NQ7
cov = load('1NQ7.mat.cov');
hb = load('1NQ7.mat.hb'); 

%interface = load('1NQ7.mat.interfaceRes'); 
%chainClass_temp = importdata('1NQ7.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1NQ7, statsWPeptide_1NQ7] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1NQ7, simpleStatsWPeptide_1NQ7] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1NQ7] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1NQ7];

clear cov hb

save 1NQ7_data;
display DONE_DATA

temp = full(minimalStats_1NQ7);
fid = fopen('minimalMotifs_1NQ7.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE