pathdef;

display 3CVP
cov = load('3CVP.mat.cov');
hb = load('3CVP.mat.hb'); 

%interface = load('3CVP.mat.interfaceRes'); 
%chainClass_temp = importdata('3CVP.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_3CVP, statsWPeptide_3CVP] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_3CVP, simpleStatsWPeptide_3CVP] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_3CVP] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_3CVP];

clear cov hb

save 3CVP_data;
display DONE_DATA

temp = full(minimalStats_3CVP);
fid = fopen('minimalMotifs_3CVP.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE