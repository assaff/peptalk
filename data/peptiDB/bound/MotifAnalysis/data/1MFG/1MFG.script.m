pathdef;

display 1MFG
cov = load('1MFG.mat.cov');
hb = load('1MFG.mat.hb'); 

%interface = load('1MFG.mat.interfaceRes'); 
%chainClass_temp = importdata('1MFG.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1MFG, statsWPeptide_1MFG] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1MFG, simpleStatsWPeptide_1MFG] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1MFG] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1MFG];

clear cov hb

save 1MFG_data;
display DONE_DATA

temp = full(minimalStats_1MFG);
fid = fopen('minimalMotifs_1MFG.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE