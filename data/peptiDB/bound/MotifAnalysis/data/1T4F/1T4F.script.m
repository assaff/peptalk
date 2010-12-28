pathdef;

display 1T4F
cov = load('1T4F.mat.cov');
hb = load('1T4F.mat.hb'); 

%interface = load('1T4F.mat.interfaceRes'); 
%chainClass_temp = importdata('1T4F.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1T4F, statsWPeptide_1T4F] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1T4F, simpleStatsWPeptide_1T4F] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1T4F] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1T4F];

clear cov hb

save 1T4F_data;
display DONE_DATA

temp = full(minimalStats_1T4F);
fid = fopen('minimalMotifs_1T4F.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE