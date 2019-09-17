% This code is to compute the displacement of each template surface node
% and prepare boundary condition files for later poisson computation.
% clear all; close all;
function ComputeDxDyDz_func()
global projectConfig;

%read the surface node coordinate from before and after deformation vtk
%file 
[Template_data, Target_data] = ReadDeformationVTKCoordinate_func();

%define displacment file name and load template surface node marking file
str='Template_Target';
filepath = projectConfig.projectDir;
group=load([filepath 'Template_group.txt']);

dxdydz=Target_data-Template_data;

k=0;
for i=1:size(group,1)
    if group(i,1)==1
        k=k+1;
        gd(i,1)=group(i,1);
        gd(i,2:4)=dxdydz(k,:);
    else
        gd(i,1)=group(i,1);
        gd(i,2:4)=[0 0 0]; 
    end
end

%write out dx dy dz respectively 

fid1 = fopen([filepath str '_dx.txt'],'w');
 
for i = 1 : size(gd,1)
    fprintf(fid1, '%i\t%f\n', gd(i,1),gd(i,2));
end
fclose(fid1);

fid2 = fopen([filepath str '_dy.txt'],'w');
 
for i = 1 : size(gd,1)
    fprintf(fid1, '%i\t%f\n', gd(i,1),gd(i,3));
end
fclose(fid2);

fid3 = fopen([filepath str '_dz.txt'],'w');
 
for i = 1 : size(gd,1)
    fprintf(fid1, '%i\t%f\n', gd(i,1),gd(i,4));
end
fclose(fid3);

       