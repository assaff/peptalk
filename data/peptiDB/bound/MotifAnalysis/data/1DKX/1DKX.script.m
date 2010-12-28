pathdef;

display 1DKX
cov = load('1DKX.mat.cov');
hb = load('1DKX.mat.hb'); 

%interface = load('1DKX.mat.interfaceRes'); 
%chainClass_temp = importdata('1DKX.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1DKX, statsWPeptide_1DKX] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1DKX, simpleStatsWPeptide_1DKX] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1DKX] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1DKX];

clear cov hb

save 1DKX_data;
display DONE_DATA

temp = full(minimalStats_1DKX);
fid = fopen('minimalMotifs_1DKX.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE