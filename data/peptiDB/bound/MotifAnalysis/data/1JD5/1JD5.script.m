pathdef;

display 1JD5
cov = load('1JD5.mat.cov');
hb = load('1JD5.mat.hb'); 

%interface = load('1JD5.mat.interfaceRes'); 
%chainClass_temp = importdata('1JD5.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1JD5, statsWPeptide_1JD5] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1JD5, simpleStatsWPeptide_1JD5] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1JD5] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1JD5];

clear cov hb

save 1JD5_data;
display DONE_DATA

temp = full(minimalStats_1JD5);
fid = fopen('minimalMotifs_1JD5.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE