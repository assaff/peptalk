pathdef;

display 1ER8
cov = load('1ER8.mat.cov');
hb = load('1ER8.mat.hb'); 

%interface = load('1ER8.mat.interfaceRes'); 
%chainClass_temp = importdata('1ER8.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1ER8, statsWPeptide_1ER8] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1ER8, simpleStatsWPeptide_1ER8] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1ER8] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1ER8];

clear cov hb

save 1ER8_data;
display DONE_DATA

temp = full(minimalStats_1ER8);
fid = fopen('minimalMotifs_1ER8.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE