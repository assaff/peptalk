pathdef;

display 3D1E
cov = load('3D1E.mat.cov');
hb = load('3D1E.mat.hb'); 

%interface = load('3D1E.mat.interfaceRes'); 
%chainClass_temp = importdata('3D1E.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_3D1E, statsWPeptide_3D1E] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_3D1E, simpleStatsWPeptide_3D1E] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_3D1E] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_3D1E];

clear cov hb

save 3D1E_data;
display DONE_DATA

temp = full(minimalStats_3D1E);
fid = fopen('minimalMotifs_3D1E.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE