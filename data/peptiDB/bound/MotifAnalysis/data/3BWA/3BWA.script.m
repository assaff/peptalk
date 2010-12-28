pathdef;

display 3BWA
cov = load('3BWA.mat.cov');
hb = load('3BWA.mat.hb'); 

%interface = load('3BWA.mat.interfaceRes'); 
%chainClass_temp = importdata('3BWA.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_3BWA, statsWPeptide_3BWA] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_3BWA, simpleStatsWPeptide_3BWA] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_3BWA] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_3BWA];

clear cov hb

save 3BWA_data;
display DONE_DATA

temp = full(minimalStats_3BWA);
fid = fopen('minimalMotifs_3BWA.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE