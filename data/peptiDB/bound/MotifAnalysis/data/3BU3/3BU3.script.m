pathdef;

display 3BU3
cov = load('3BU3.mat.cov');
hb = load('3BU3.mat.hb'); 

%interface = load('3BU3.mat.interfaceRes'); 
%chainClass_temp = importdata('3BU3.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_3BU3, statsWPeptide_3BU3] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_3BU3, simpleStatsWPeptide_3BU3] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_3BU3] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_3BU3];

clear cov hb

save 3BU3_data;
display DONE_DATA

temp = full(minimalStats_3BU3);
fid = fopen('minimalMotifs_3BU3.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE