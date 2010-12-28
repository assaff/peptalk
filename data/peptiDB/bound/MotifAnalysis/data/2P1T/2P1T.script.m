pathdef;

display 2P1T
cov = load('2P1T.mat.cov');
hb = load('2P1T.mat.hb'); 

%interface = load('2P1T.mat.interfaceRes'); 
%chainClass_temp = importdata('2P1T.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2P1T, statsWPeptide_2P1T] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2P1T, simpleStatsWPeptide_2P1T] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2P1T] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2P1T];

clear cov hb

save 2P1T_data;
display DONE_DATA

temp = full(minimalStats_2P1T);
fid = fopen('minimalMotifs_2P1T.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE