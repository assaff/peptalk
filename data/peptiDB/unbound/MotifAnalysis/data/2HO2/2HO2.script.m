pathdef;

display 2HO2
cov = load('2HO2.mat.cov');
hb = load('2HO2.mat.hb'); 

%interface = load('2HO2.mat.interfaceRes'); 
%chainClass_temp = importdata('2HO2.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2HO2, statsWPeptide_2HO2] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2HO2, simpleStatsWPeptide_2HO2] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2HO2] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2HO2];

clear cov hb

save 2HO2_data;
display DONE_DATA

temp = full(minimalStats_2HO2);
fid = fopen('minimalMotifs_2HO2.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE