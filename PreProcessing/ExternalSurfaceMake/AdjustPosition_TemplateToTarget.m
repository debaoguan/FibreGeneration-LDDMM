%this code is to adjust the position of tempalte mesh, becasue LDDMM algorithm can only 
%deal with two geometries that are in same size range in same position
clear all; close all;

filepath='E:\HaoGao\PhDs\PhD_DebaoGuan\LDDMM MAP\LDDMM_Mapping\InputOutputFile';

element=load([filepath '\Cannie_element.txt']);
fibre_sheet=load([filepath '\Template_f_s_n.txt.txt']);



%change node data. there are several estimated value from ABAQUS analysis.

r=0.45; %estimated size ratio between two geometries
tr=[30.5640   -0.9105   22.7000]; %estimated geometry center of tempalte LV cap

%estimated rotation around y axis angel from tempalte to target
thet=180/180*pi; 
%compute rotation matrix 
Ry=[cos(thet) 0 sin(thet);
    0 1 0;
    -sin(thet) 0 cos(thet)];

%estimated rotation around z axis angel from tempalte to target
gama=-45/180*pi;
Rz=[cos(gama) sin(gama) 0;
    -sin(gama) cos(gama) 0;
    0 0 1];

%final rotation matrix
TR=Ry*Rz;

%change size and position of tempalte mesh
b=[];
for i = 1 : size(node,1)
    a1=[];a2=[];a3=[];
    a1=node(i,2:4)-tr;
    a2=a1*r;
    a3=TR*a2';
    
    b(i,1)=i;
    b(i,2:4)=a3';
end

%correspondingly change fibre direction
c=[];
for i = 1 : size(element,1)
    f=[];s=[];
    
    f=TR*fibre_sheet(i,2:4)';
%    s=TR*fibre_sheet(i,5:7)';
    
    c(i,1)=i;
    c(i,2:4)=f';
%    c(i,5:7)=s';
end

%write out the adjusted node, element and fibre
fid1 = fopen([filepath 'Template_node.txt'],'w');
 
for i = 1 : size(b,1)
    fprintf(fid1, '%i\t, %f\t, %f\t, %f\n', b(i,1),b(i,2),b(i,3),b(i,4));
end
fclose(fid1);

fid3 = fopen([filepath 'Template_element.txt'],'w');
 
for i = 1 : size(element,1)
    fprintf(fid1, '%i\t, %f\t, %f\t, %f\n', element(i,1),element(i,2),element(i,3),element(i,4));
end
fclose(fid3);

fid2 = fopen([filepath 'Template_fibre_adjust.txt'],'w');
 
for i = 1 : size(c,1)
    fprintf(fid2, '%i\t %f\t %f\t %f\n', c(i,1),c(i,2),c(i,3),c(i,4));
end
fclose(fid2);






