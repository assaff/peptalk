pathdef;

display 1NLN
cov = load('1NLN.mat.cov');
hb = load('1NLN.mat.hb'); 

%interface = load('1NLN.mat.interfaceRes'); 
%chainClass_temp = importdata('1NLN.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1NLN, statsWPeptide_1NLN] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1NLN, simpleStatsWPeptide_1NLN] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1NLN] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1NLN];

clear cov hb

save 1NLN_data;
display DONE_DATA

temp = full(minimalStats_1NLN);
fid = fopen('minimalMotifs_1NLN.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE