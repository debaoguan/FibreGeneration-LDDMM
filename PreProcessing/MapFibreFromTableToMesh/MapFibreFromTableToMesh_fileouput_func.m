function MapFibreFromTableToMesh_fileouput_func(fibre_sheet)
% build output file and write out
global projectConfig;

workingDir = projectConfig.workingDir;

cd(projectConfig.projectDir);
    fid1 = fopen(projectConfig.fibre_sheet_cannieheart_angle_direction, 'w');
cd(workingDir);
 
for i = 1 : size(fibre_sheet,1)
    fprintf(fid1, '%i\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n',...
        i, fibre_sheet(i,1),fibre_sheet(i,2),fibre_sheet(i,3),fibre_sheet(i,4),fibre_sheet(i,5),...
        fibre_sheet(i,6),fibre_sheet(i,7),fibre_sheet(i,8),fibre_sheet(i,9),fibre_sheet(i,10),...
        fibre_sheet(i,11),fibre_sheet(i,12),fibre_sheet(i,13),fibre_sheet(i,14));
end
fclose(fid1);

%check whether there is empty element
any=isnan(fibre_sheet);
find(any==1);

%write out fibre file
cd(projectConfig.projectDir);
 fid2 = fopen(projectConfig.Template_f_s_n, 'w');
cd(workingDir);
 
for i = 1 : size(fibre_sheet,1)
    fprintf(fid1, '%i\t %f\t %f\t %f\n',i,... 
    fibre_sheet(i,6),fibre_sheet(i,7),fibre_sheet(i,8));
end
fclose(fid2);