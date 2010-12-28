pathdef;

display 2VJ0
cov = load('2VJ0.mat.cov');
hb = load('2VJ0.mat.hb'); 

%interface = load('2VJ0.mat.interfaceRes'); 
%chainClass_temp = importdata('2VJ0.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2VJ0, statsWPeptide_2VJ0] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2VJ0, simpleStatsWPeptide_2VJ0] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2VJ0] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2VJ0];

clear cov hb

save 2VJ0_data;
display DONE_DATA

temp = full(minimalStats_2VJ0);
fid = fopen('minimalMotifs_2VJ0.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE