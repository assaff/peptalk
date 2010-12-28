pathdef;

display 2FVJ
cov = load('2FVJ.mat.cov');
hb = load('2FVJ.mat.hb'); 

%interface = load('2FVJ.mat.interfaceRes'); 
%chainClass_temp = importdata('2FVJ.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_2FVJ, statsWPeptide_2FVJ] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_2FVJ, simpleStatsWPeptide_2FVJ] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_2FVJ] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_2FVJ];

clear cov hb

save 2FVJ_data;
display DONE_DATA

temp = full(minimalStats_2FVJ);
fid = fopen('minimalMotifs_2FVJ.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE