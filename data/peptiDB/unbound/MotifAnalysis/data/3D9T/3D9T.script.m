pathdef;

display 3D9T
cov = load('3D9T.mat.cov');
hb = load('3D9T.mat.hb'); 

%interface = load('3D9T.mat.interfaceRes'); 
%chainClass_temp = importdata('3D9T.mat.chainClass');
%chainClass = char(chainClass_temp(:));
%clear chainClass_temp

%mainChainInterface = (interface(:) == 1) & (chainClass(:) == 'A');

%[stats_3D9T, statsWPeptide_3D9T] = motifStatistics(hb, cov, chainClass);

bonds_total = cov + hb;
%[simpleStats_3D9T, simpleStatsWPeptide_3D9T] = simpleMotifStatistics(bonds_total, chainClass);
[minimalStats_3D9T] = minimalMotifStatistics(bonds_total);

%review = [mainChainInterface minimalStats_3D9T];

clear cov hb

save 3D9T_data;
display DONE_DATA

temp = full(minimalStats_3D9T);
fid = fopen('minimalMotifs_3D9T.txt', 'w');
for i=1:size(temp,1)
    for j=1:size(temp,2)
        fprintf(fid, '%d ', temp(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

display DONE_SAVE

display DONE