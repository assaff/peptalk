pathdef;

display 1T7R
cov = load('1T7R.mat.cov');
hb = load('1T7R.mat.hb'); 

%interface = load('1T7R.mat.interfaceRes'); 
%chainClass_temp = importdata('1T7R.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1T7R, statsWPeptide_1T7R] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1T7R, simpleStatsWPeptide_1T7R] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1T7R] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1T7R];

clear cov hb

save 1T7R_data;
display DONE_DATA

temp = full(minimalStats_1T7R);
fid = fopen('minimalMotifs_1T7R.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE