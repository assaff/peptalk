pathdef;

display 1GYB
cov = load('1GYB.mat.cov');
hb = load('1GYB.mat.hb'); 

%interface = load('1GYB.mat.interfaceRes'); 
%chainClass_temp = importdata('1GYB.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1GYB, statsWPeptide_1GYB] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1GYB, simpleStatsWPeptide_1GYB] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1GYB] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1GYB];

clear cov hb

save 1GYB_data;
display DONE_DATA

temp = full(minimalStats_1GYB);
fid = fopen('minimalMotifs_1GYB.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE