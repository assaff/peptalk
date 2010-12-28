pathdef;

display 2DS8
cov = load('2DS8.mat.cov');
hb = load('2DS8.mat.hb'); 

%interface = load('2DS8.mat.interfaceRes'); 
%chainClass_temp = importdata('2DS8.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2DS8, statsWPeptide_2DS8] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2DS8, simpleStatsWPeptide_2DS8] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2DS8] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2DS8];

clear cov hb

save 2DS8_data;
display DONE_DATA

temp = full(minimalStats_2DS8);
fid = fopen('minimalMotifs_2DS8.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE