pathdef;

display 1YMT
cov = load('1YMT.mat.cov');
hb = load('1YMT.mat.hb'); 

%interface = load('1YMT.mat.interfaceRes'); 
%chainClass_temp = importdata('1YMT.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1YMT, statsWPeptide_1YMT] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1YMT, simpleStatsWPeptide_1YMT] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1YMT] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1YMT];

clear cov hb

save 1YMT_data;
display DONE_DATA

temp = full(minimalStats_1YMT);
fid = fopen('minimalMotifs_1YMT.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE