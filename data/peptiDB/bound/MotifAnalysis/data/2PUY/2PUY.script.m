pathdef;

display 2PUY
cov = load('2PUY.mat.cov');
hb = load('2PUY.mat.hb'); 

%interface = load('2PUY.mat.interfaceRes'); 
%chainClass_temp = importdata('2PUY.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2PUY, statsWPeptide_2PUY] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2PUY, simpleStatsWPeptide_2PUY] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2PUY] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2PUY];

clear cov hb

save 2PUY_data;
display DONE_DATA

temp = full(minimalStats_2PUY);
fid = fopen('minimalMotifs_2PUY.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE