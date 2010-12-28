pathdef;

display 2FOJ
cov = load('2FOJ.mat.cov');
hb = load('2FOJ.mat.hb'); 

%interface = load('2FOJ.mat.interfaceRes'); 
%chainClass_temp = importdata('2FOJ.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2FOJ, statsWPeptide_2FOJ] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2FOJ, simpleStatsWPeptide_2FOJ] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2FOJ] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2FOJ];

clear cov hb

save 2FOJ_data;
display DONE_DATA

temp = full(minimalStats_2FOJ);
fid = fopen('minimalMotifs_2FOJ.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE