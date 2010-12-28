pathdef;

display 2O4J
cov = load('2O4J.mat.cov');
hb = load('2O4J.mat.hb'); 

%interface = load('2O4J.mat.interfaceRes'); 
%chainClass_temp = importdata('2O4J.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2O4J, statsWPeptide_2O4J] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2O4J, simpleStatsWPeptide_2O4J] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2O4J] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2O4J];

clear cov hb

save 2O4J_data;
display DONE_DATA

temp = full(minimalStats_2O4J);
fid = fopen('minimalMotifs_2O4J.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE