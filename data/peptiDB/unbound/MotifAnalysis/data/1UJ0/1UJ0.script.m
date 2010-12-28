pathdef;

display 1UJ0
cov = load('1UJ0.mat.cov');
hb = load('1UJ0.mat.hb'); 

%interface = load('1UJ0.mat.interfaceRes'); 
%chainClass_temp = importdata('1UJ0.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1UJ0, statsWPeptide_1UJ0] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1UJ0, simpleStatsWPeptide_1UJ0] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1UJ0] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1UJ0];

clear cov hb

save 1UJ0_data;
display DONE_DATA

temp = full(minimalStats_1UJ0);
fid = fopen('minimalMotifs_1UJ0.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE