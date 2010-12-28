pathdef;

display 1NX1
cov = load('1NX1.mat.cov');
hb = load('1NX1.mat.hb'); 

%interface = load('1NX1.mat.interfaceRes'); 
%chainClass_temp = importdata('1NX1.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1NX1, statsWPeptide_1NX1] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1NX1, simpleStatsWPeptide_1NX1] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1NX1] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1NX1];

clear cov hb

save 1NX1_data;
display DONE_DATA

temp = full(minimalStats_1NX1);
fid = fopen('minimalMotifs_1NX1.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE