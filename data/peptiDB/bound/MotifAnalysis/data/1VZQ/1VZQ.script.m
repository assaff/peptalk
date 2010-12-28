pathdef;

display 1VZQ
cov = load('1VZQ.mat.cov');
hb = load('1VZQ.mat.hb'); 

%interface = load('1VZQ.mat.interfaceRes'); 
%chainClass_temp = importdata('1VZQ.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1VZQ, statsWPeptide_1VZQ] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1VZQ, simpleStatsWPeptide_1VZQ] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1VZQ] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1VZQ];

clear cov hb

save 1VZQ_data;
display DONE_DATA

temp = full(minimalStats_1VZQ);
fid = fopen('minimalMotifs_1VZQ.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE