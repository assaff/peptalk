pathdef;

display 2V3S
cov = load('2V3S.mat.cov');
hb = load('2V3S.mat.hb'); 

%interface = load('2V3S.mat.interfaceRes'); 
%chainClass_temp = importdata('2V3S.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2V3S, statsWPeptide_2V3S] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2V3S, simpleStatsWPeptide_2V3S] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2V3S] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2V3S];

clear cov hb

save 2V3S_data;
display DONE_DATA

temp = full(minimalStats_2V3S);
fid = fopen('minimalMotifs_2V3S.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE