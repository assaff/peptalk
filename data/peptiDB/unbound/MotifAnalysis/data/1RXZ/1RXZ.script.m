pathdef;

display 1RXZ
cov = load('1RXZ.mat.cov');
hb = load('1RXZ.mat.hb'); 

%interface = load('1RXZ.mat.interfaceRes'); 
%chainClass_temp = importdata('1RXZ.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1RXZ, statsWPeptide_1RXZ] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1RXZ, simpleStatsWPeptide_1RXZ] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1RXZ] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1RXZ];

clear cov hb

save 1RXZ_data;
display DONE_DATA

temp = full(minimalStats_1RXZ);
fid = fopen('minimalMotifs_1RXZ.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE