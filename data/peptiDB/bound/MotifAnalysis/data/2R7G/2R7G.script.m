pathdef;

display 2R7G
cov = load('2R7G.mat.cov');
hb = load('2R7G.mat.hb'); 

%interface = load('2R7G.mat.interfaceRes'); 
%chainClass_temp = importdata('2R7G.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2R7G, statsWPeptide_2R7G] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2R7G, simpleStatsWPeptide_2R7G] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2R7G] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2R7G];

clear cov hb

save 2R7G_data;
display DONE_DATA

temp = full(minimalStats_2R7G);
fid = fopen('minimalMotifs_2R7G.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE