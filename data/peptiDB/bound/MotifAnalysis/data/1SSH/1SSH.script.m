pathdef;

display 1SSH
cov = load('1SSH.mat.cov');
hb = load('1SSH.mat.hb'); 

%interface = load('1SSH.mat.interfaceRes'); 
%chainClass_temp = importdata('1SSH.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1SSH, statsWPeptide_1SSH] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1SSH, simpleStatsWPeptide_1SSH] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1SSH] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1SSH];

clear cov hb

save 1SSH_data;
display DONE_DATA

temp = full(minimalStats_1SSH);
fid = fopen('minimalMotifs_1SSH.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE