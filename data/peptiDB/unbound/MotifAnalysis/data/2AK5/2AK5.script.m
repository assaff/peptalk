pathdef;

display 2AK5
cov = load('2AK5.mat.cov');
hb = load('2AK5.mat.hb'); 

%interface = load('2AK5.mat.interfaceRes'); 
%chainClass_temp = importdata('2AK5.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2AK5, statsWPeptide_2AK5] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2AK5, simpleStatsWPeptide_2AK5] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2AK5] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2AK5];

clear cov hb

save 2AK5_data;
display DONE_DATA

temp = full(minimalStats_2AK5);
fid = fopen('minimalMotifs_2AK5.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE