pathdef;

display 1TP5
cov = load('1TP5.mat.cov');
hb = load('1TP5.mat.hb'); 

%interface = load('1TP5.mat.interfaceRes'); 
%chainClass_temp = importdata('1TP5.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1TP5, statsWPeptide_1TP5] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1TP5, simpleStatsWPeptide_1TP5] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1TP5] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1TP5];

clear cov hb

save 1TP5_data;
display DONE_DATA

temp = full(minimalStats_1TP5);
fid = fopen('minimalMotifs_1TP5.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE