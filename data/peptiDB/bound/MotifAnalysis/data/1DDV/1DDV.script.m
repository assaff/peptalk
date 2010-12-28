pathdef;

display 1DDV
cov = load('1DDV.mat.cov');
hb = load('1DDV.mat.hb'); 

%interface = load('1DDV.mat.interfaceRes'); 
%chainClass_temp = importdata('1DDV.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1DDV, statsWPeptide_1DDV] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1DDV, simpleStatsWPeptide_1DDV] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1DDV] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1DDV];

clear cov hb

save 1DDV_data;
display DONE_DATA

temp = full(minimalStats_1DDV);
fid = fopen('minimalMotifs_1DDV.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE