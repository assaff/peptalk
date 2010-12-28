pathdef;

display 2P1K
cov = load('2P1K.mat.cov');
hb = load('2P1K.mat.hb'); 

%interface = load('2P1K.mat.interfaceRes'); 
%chainClass_temp = importdata('2P1K.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2P1K, statsWPeptide_2P1K] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2P1K, simpleStatsWPeptide_2P1K] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2P1K] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2P1K];

clear cov hb

save 2P1K_data;
display DONE_DATA

temp = full(minimalStats_2P1K);
fid = fopen('minimalMotifs_2P1K.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE