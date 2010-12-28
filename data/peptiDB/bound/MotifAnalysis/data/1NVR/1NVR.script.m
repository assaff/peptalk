pathdef;

display 1NVR
cov = load('1NVR.mat.cov');
hb = load('1NVR.mat.hb'); 

%interface = load('1NVR.mat.interfaceRes'); 
%chainClass_temp = importdata('1NVR.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_1NVR, statsWPeptide_1NVR] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_1NVR, simpleStatsWPeptide_1NVR] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_1NVR] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_1NVR];

clear cov hb

save 1NVR_data;
display DONE_DATA

temp = full(minimalStats_1NVR);
fid = fopen('minimalMotifs_1NVR.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE