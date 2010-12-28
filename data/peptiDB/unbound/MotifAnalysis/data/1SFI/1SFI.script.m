pathdef;

display 1SFI
cov = load('1SFI.mat.cov');
hb = load('1SFI.mat.hb'); 

%interface = load('1SFI.mat.interfaceRes'); 
%chainClass_temp = importdata('1SFI.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1SFI, statsWPeptide_1SFI] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1SFI, simpleStatsWPeptide_1SFI] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1SFI] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1SFI];

clear cov hb

save 1SFI_data;
display DONE_DATA

temp = full(minimalStats_1SFI);
fid = fopen('minimalMotifs_1SFI.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE