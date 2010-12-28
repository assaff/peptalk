pathdef;

display 1X2R
cov = load('1X2R.mat.cov');
hb = load('1X2R.mat.hb'); 

%interface = load('1X2R.mat.interfaceRes'); 
%chainClass_temp = importdata('1X2R.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1X2R, statsWPeptide_1X2R] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1X2R, simpleStatsWPeptide_1X2R] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1X2R] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1X2R];

clear cov hb

save 1X2R_data;
display DONE_DATA

temp = full(minimalStats_1X2R);
fid = fopen('minimalMotifs_1X2R.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE