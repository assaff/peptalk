pathdef;

display 2D0N
cov = load('2D0N.mat.cov');
hb = load('2D0N.mat.hb'); 

%interface = load('2D0N.mat.interfaceRes'); 
%chainClass_temp = importdata('2D0N.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2D0N, statsWPeptide_2D0N] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2D0N, simpleStatsWPeptide_2D0N] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2D0N] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2D0N];

clear cov hb

save 2D0N_data;
display DONE_DATA

temp = full(minimalStats_2D0N);
fid = fopen('minimalMotifs_2D0N.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE