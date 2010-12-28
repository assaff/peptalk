pathdef;

display 1OAI
cov = load('1OAI.mat.cov');
hb = load('1OAI.mat.hb'); 

%interface = load('1OAI.mat.interfaceRes'); 
%chainClass_temp = importdata('1OAI.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1OAI, statsWPeptide_1OAI] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1OAI, simpleStatsWPeptide_1OAI] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1OAI] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1OAI];

clear cov hb

save 1OAI_data;
display DONE_DATA

temp = full(minimalStats_1OAI);
fid = fopen('minimalMotifs_1OAI.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE