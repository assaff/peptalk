pathdef;

display 1CKA
cov = load('1CKA.mat.cov');
hb = load('1CKA.mat.hb'); 

%interface = load('1CKA.mat.interfaceRes'); 
%chainClass_temp = importdata('1CKA.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1CKA, statsWPeptide_1CKA] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1CKA, simpleStatsWPeptide_1CKA] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1CKA] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1CKA];

clear cov hb

save 1CKA_data;
display DONE_DATA

temp = full(minimalStats_1CKA);
fid = fopen('minimalMotifs_1CKA.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE