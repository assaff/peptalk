pathdef;

display 2QOS
cov = load('2QOS.mat.cov');
hb = load('2QOS.mat.hb'); 

%interface = load('2QOS.mat.interfaceRes'); 
%chainClass_temp = importdata('2QOS.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2QOS, statsWPeptide_2QOS] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2QOS, simpleStatsWPeptide_2QOS] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2QOS] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2QOS];

clear cov hb

save 2QOS_data;
display DONE_DATA

temp = full(minimalStats_2QOS);
fid = fopen('minimalMotifs_2QOS.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE