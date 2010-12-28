pathdef;

display 1AWR
cov = load('1AWR.mat.cov');
hb = load('1AWR.mat.hb'); 

%interface = load('1AWR.mat.interfaceRes'); 
%chainClass_temp = importdata('1AWR.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1AWR, statsWPeptide_1AWR] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1AWR, simpleStatsWPeptide_1AWR] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1AWR] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1AWR];

clear cov hb

save 1AWR_data;
display DONE_DATA

temp = full(minimalStats_1AWR);
fid = fopen('minimalMotifs_1AWR.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE