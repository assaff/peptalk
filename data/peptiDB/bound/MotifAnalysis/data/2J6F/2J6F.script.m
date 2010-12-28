pathdef;

display 2J6F
cov = load('2J6F.mat.cov');
hb = load('2J6F.mat.hb'); 

%interface = load('2J6F.mat.interfaceRes'); 
%chainClass_temp = importdata('2J6F.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2J6F, statsWPeptide_2J6F] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2J6F, simpleStatsWPeptide_2J6F] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2J6F] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2J6F];

clear cov hb

save 2J6F_data;
display DONE_DATA

temp = full(minimalStats_2J6F);
fid = fopen('minimalMotifs_2J6F.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE