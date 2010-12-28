pathdef;

display 1IHJ
cov = load('1IHJ.mat.cov');
hb = load('1IHJ.mat.hb'); 

%interface = load('1IHJ.mat.interfaceRes'); 
%chainClass_temp = importdata('1IHJ.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1IHJ, statsWPeptide_1IHJ] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1IHJ, simpleStatsWPeptide_1IHJ] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1IHJ] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1IHJ];

clear cov hb

save 1IHJ_data;
display DONE_DATA

temp = full(minimalStats_1IHJ);
fid = fopen('minimalMotifs_1IHJ.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE