pathdef;

display 2P54
cov = load('2P54.mat.cov');
hb = load('2P54.mat.hb'); 

%interface = load('2P54.mat.interfaceRes'); 
%chainClass_temp = importdata('2P54.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2P54, statsWPeptide_2P54] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2P54, simpleStatsWPeptide_2P54] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2P54] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2P54];

clear cov hb

save 2P54_data;
display DONE_DATA

temp = full(minimalStats_2P54);
fid = fopen('minimalMotifs_2P54.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE