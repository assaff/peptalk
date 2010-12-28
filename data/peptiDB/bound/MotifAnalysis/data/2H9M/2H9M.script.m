pathdef;

display 2H9M
cov = load('2H9M.mat.cov');
hb = load('2H9M.mat.hb'); 

%interface = load('2H9M.mat.interfaceRes'); 
%chainClass_temp = importdata('2H9M.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2H9M, statsWPeptide_2H9M] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2H9M, simpleStatsWPeptide_2H9M] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2H9M] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2H9M];

clear cov hb

save 2H9M_data;
display DONE_DATA

temp = full(minimalStats_2H9M);
fid = fopen('minimalMotifs_2H9M.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE