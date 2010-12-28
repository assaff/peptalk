pathdef;

display 1EG4
cov = load('1EG4.mat.cov');
hb = load('1EG4.mat.hb'); 

%interface = load('1EG4.mat.interfaceRes'); 
%chainClass_temp = importdata('1EG4.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1EG4, statsWPeptide_1EG4] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1EG4, simpleStatsWPeptide_1EG4] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1EG4] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1EG4];

clear cov hb

save 1EG4_data;
display DONE_DATA

temp = full(minimalStats_1EG4);
fid = fopen('minimalMotifs_1EG4.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE