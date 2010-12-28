pathdef;

display 1QKZ
cov = load('1QKZ.mat.cov');
hb = load('1QKZ.mat.hb'); 

%interface = load('1QKZ.mat.interfaceRes'); 
%chainClass_temp = importdata('1QKZ.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1QKZ, statsWPeptide_1QKZ] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1QKZ, simpleStatsWPeptide_1QKZ] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1QKZ] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1QKZ];

clear cov hb

save 1QKZ_data;
display DONE_DATA

temp = full(minimalStats_1QKZ);
fid = fopen('minimalMotifs_1QKZ.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE