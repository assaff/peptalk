pathdef;

display 2B1Z
cov = load('2B1Z.mat.cov');
hb = load('2B1Z.mat.hb'); 

%interface = load('2B1Z.mat.interfaceRes'); 
%chainClass_temp = importdata('2B1Z.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2B1Z, statsWPeptide_2B1Z] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2B1Z, simpleStatsWPeptide_2B1Z] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2B1Z] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2B1Z];

clear cov hb

save 2B1Z_data;
display DONE_DATA

temp = full(minimalStats_2B1Z);
fid = fopen('minimalMotifs_2B1Z.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE