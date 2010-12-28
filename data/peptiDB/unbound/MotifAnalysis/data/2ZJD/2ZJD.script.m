pathdef;

display 2ZJD
cov = load('2ZJD.mat.cov');
hb = load('2ZJD.mat.hb'); 

%interface = load('2ZJD.mat.interfaceRes'); 
%chainClass_temp = importdata('2ZJD.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2ZJD, statsWPeptide_2ZJD] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2ZJD, simpleStatsWPeptide_2ZJD] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2ZJD] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2ZJD];

clear cov hb

save 2ZJD_data;
display DONE_DATA

temp = full(minimalStats_2ZJD);
fid = fopen('minimalMotifs_2ZJD.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE