pathdef;

display 2BBA
cov = load('2BBA.mat.cov');
hb = load('2BBA.mat.hb'); 

%interface = load('2BBA.mat.interfaceRes'); 
%chainClass_temp = importdata('2BBA.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2BBA, statsWPeptide_2BBA] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2BBA, simpleStatsWPeptide_2BBA] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2BBA] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2BBA];

clear cov hb

save 2BBA_data;
display DONE_DATA

temp = full(minimalStats_2BBA);
fid = fopen('minimalMotifs_2BBA.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE