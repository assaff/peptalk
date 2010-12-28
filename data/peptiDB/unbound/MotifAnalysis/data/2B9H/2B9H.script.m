pathdef;

display 2B9H
cov = load('2B9H.mat.cov');
hb = load('2B9H.mat.hb'); 

%interface = load('2B9H.mat.interfaceRes'); 
%chainClass_temp = importdata('2B9H.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2B9H, statsWPeptide_2B9H] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2B9H, simpleStatsWPeptide_2B9H] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2B9H] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2B9H];

clear cov hb

save 2B9H_data;
display DONE_DATA

temp = full(minimalStats_2B9H);
fid = fopen('minimalMotifs_2B9H.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE