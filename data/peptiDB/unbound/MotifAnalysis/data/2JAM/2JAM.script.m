pathdef;

display 2JAM
cov = load('2JAM.mat.cov');
hb = load('2JAM.mat.hb'); 

%interface = load('2JAM.mat.interfaceRes'); 
%chainClass_temp = importdata('2JAM.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2JAM, statsWPeptide_2JAM] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2JAM, simpleStatsWPeptide_2JAM] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2JAM] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2JAM];

clear cov hb

save 2JAM_data;
display DONE_DATA

temp = full(minimalStats_2JAM);
fid = fopen('minimalMotifs_2JAM.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE