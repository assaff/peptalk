pathdef;

display 1NTV
cov = load('1NTV.mat.cov');
hb = load('1NTV.mat.hb'); 

%interface = load('1NTV.mat.interfaceRes'); 
%chainClass_temp = importdata('1NTV.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1NTV, statsWPeptide_1NTV] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1NTV, simpleStatsWPeptide_1NTV] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1NTV] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1NTV];

clear cov hb

save 1NTV_data;
display DONE_DATA

temp = full(minimalStats_1NTV);
fid = fopen('minimalMotifs_1NTV.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE