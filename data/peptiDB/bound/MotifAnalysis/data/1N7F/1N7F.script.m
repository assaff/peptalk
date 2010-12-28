pathdef;

display 1N7F
cov = load('1N7F.mat.cov');
hb = load('1N7F.mat.hb'); 

%interface = load('1N7F.mat.interfaceRes'); 
%chainClass_temp = importdata('1N7F.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1N7F, statsWPeptide_1N7F] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1N7F, simpleStatsWPeptide_1N7F] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1N7F] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1N7F];

clear cov hb

save 1N7F_data;
display DONE_DATA

temp = full(minimalStats_1N7F);
fid = fopen('minimalMotifs_1N7F.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE