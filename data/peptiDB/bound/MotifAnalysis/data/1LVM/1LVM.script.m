pathdef;

display 1LVM
cov = load('1LVM.mat.cov');
hb = load('1LVM.mat.hb'); 

%interface = load('1LVM.mat.interfaceRes'); 
%chainClass_temp = importdata('1LVM.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1LVM, statsWPeptide_1LVM] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1LVM, simpleStatsWPeptide_1LVM] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1LVM] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1LVM];

clear cov hb

save 1LVM_data;
display DONE_DATA

temp = full(minimalStats_1LVM);
fid = fopen('minimalMotifs_1LVM.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE