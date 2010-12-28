pathdef;

display 1JWG
cov = load('1JWG.mat.cov');
hb = load('1JWG.mat.hb'); 

%interface = load('1JWG.mat.interfaceRes'); 
%chainClass_temp = importdata('1JWG.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1JWG, statsWPeptide_1JWG] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1JWG, simpleStatsWPeptide_1JWG] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1JWG] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1JWG];

clear cov hb

save 1JWG_data;
display DONE_DATA

temp = full(minimalStats_1JWG);
fid = fopen('minimalMotifs_1JWG.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE