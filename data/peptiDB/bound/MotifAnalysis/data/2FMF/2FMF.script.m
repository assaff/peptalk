pathdef;

display 2FMF
cov = load('2FMF.mat.cov');
hb = load('2FMF.mat.hb'); 

%interface = load('2FMF.mat.interfaceRes'); 
%chainClass_temp = importdata('2FMF.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2FMF, statsWPeptide_2FMF] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2FMF, simpleStatsWPeptide_2FMF] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2FMF] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2FMF];

clear cov hb

save 2FMF_data;
display DONE_DATA

temp = full(minimalStats_2FMF);
fid = fopen('minimalMotifs_2FMF.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE