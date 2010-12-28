pathdef;

display 2A3I
cov = load('2A3I.mat.cov');
hb = load('2A3I.mat.hb'); 

%interface = load('2A3I.mat.interfaceRes'); 
%chainClass_temp = importdata('2A3I.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2A3I, statsWPeptide_2A3I] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2A3I, simpleStatsWPeptide_2A3I] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2A3I] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2A3I];

clear cov hb

save 2A3I_data;
display DONE_DATA

temp = full(minimalStats_2A3I);
fid = fopen('minimalMotifs_2A3I.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE