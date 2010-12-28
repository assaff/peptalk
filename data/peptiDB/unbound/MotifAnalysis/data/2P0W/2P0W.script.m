pathdef;

display 2P0W
cov = load('2P0W.mat.cov');
hb = load('2P0W.mat.hb'); 

%interface = load('2P0W.mat.interfaceRes'); 
%chainClass_temp = importdata('2P0W.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2P0W, statsWPeptide_2P0W] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2P0W, simpleStatsWPeptide_2P0W] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2P0W] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2P0W];

clear cov hb

save 2P0W_data;
display DONE_DATA

temp = full(minimalStats_2P0W);
fid = fopen('minimalMotifs_2P0W.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE