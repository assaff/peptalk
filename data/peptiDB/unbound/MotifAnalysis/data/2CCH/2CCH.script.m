pathdef;

display 2CCH
cov = load('2CCH.mat.cov');
hb = load('2CCH.mat.hb'); 

%interface = load('2CCH.mat.interfaceRes'); 
%chainClass_temp = importdata('2CCH.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2CCH, statsWPeptide_2CCH] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2CCH, simpleStatsWPeptide_2CCH] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2CCH] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2CCH];

clear cov hb

save 2CCH_data;
display DONE_DATA

temp = full(minimalStats_2CCH);
fid = fopen('minimalMotifs_2CCH.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE