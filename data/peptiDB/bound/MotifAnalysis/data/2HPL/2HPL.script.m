pathdef;

display 2HPL
cov = load('2HPL.mat.cov');
hb = load('2HPL.mat.hb'); 

%interface = load('2HPL.mat.interfaceRes'); 
%chainClass_temp = importdata('2HPL.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2HPL, statsWPeptide_2HPL] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2HPL, simpleStatsWPeptide_2HPL] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2HPL] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2HPL];

clear cov hb

save 2HPL_data;
display DONE_DATA

temp = full(minimalStats_2HPL);
fid = fopen('minimalMotifs_2HPL.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE