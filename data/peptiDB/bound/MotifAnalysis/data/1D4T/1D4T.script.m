pathdef;

display 1D4T
cov = load('1D4T.mat.cov');
hb = load('1D4T.mat.hb'); 

%interface = load('1D4T.mat.interfaceRes'); 
%chainClass_temp = importdata('1D4T.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1D4T, statsWPeptide_1D4T] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1D4T, simpleStatsWPeptide_1D4T] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1D4T] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1D4T];

clear cov hb

save 1D4T_data;
display DONE_DATA

temp = full(minimalStats_1D4T);
fid = fopen('minimalMotifs_1D4T.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE