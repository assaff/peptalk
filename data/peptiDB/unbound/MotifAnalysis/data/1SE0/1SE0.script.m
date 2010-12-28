pathdef;

display 1SE0
cov = load('1SE0.mat.cov');
hb = load('1SE0.mat.hb'); 

%interface = load('1SE0.mat.interfaceRes'); 
%chainClass_temp = importdata('1SE0.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1SE0, statsWPeptide_1SE0] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1SE0, simpleStatsWPeptide_1SE0] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1SE0] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1SE0];

clear cov hb

save 1SE0_data;
display DONE_DATA

temp = full(minimalStats_1SE0);
fid = fopen('minimalMotifs_1SE0.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE