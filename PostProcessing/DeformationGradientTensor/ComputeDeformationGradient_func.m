%this code is to compute the deformation gradient tensor of C3D4 element
% clear all; close all;
function ComputeDeformationGradient_func()
global projectConfig;


%load template mesh data and deformation data
% filepath='D:\DBGuan\DTMRImapping\MatlabCode - Copy\InputOutputFile\';
filepath = projectConfig.projectDir;
node=load([filepath '\Template_node.txt']);
element=load([filepath '\Template_element.txt']);
node_dxdydz=load([filepath '\Template_node_dxdydz.txt']);
fibre=load([filepath '\Template_fibre_adjust.txt']);

node = node(:, 2:4);
element = element(:, 2:5);
fibre = fibre(:, 2:4);

for i=1:size(element,1)
    xyztet=[];
    for j=1:4 %%here are the changes 
        xyztet(1,j)=node(element(i,j),1);
        xyztet(2,j)=node(element(i,j),2);
        xyztet(3,j)=node(element(i,j),3);
        
        dxdydz(1,j)=node_dxdydz(element(i,j),1);
        dxdydz(2,j)=node_dxdydz(element(i,j),2);
        dxdydz(3,j)=node_dxdydz(element(i,j),3);
    end
    
    [abc, Vcol]=IsoTet4ShapeFunDer(xyztet);
    
	%the deformation gradient tensor
    F=[];
    F=eye(3)+(dxdydz*abc)/6/Vcol;
    
	%compute fibre after deformation
    fibre_sheet(i,1:3)=(F*fibre(i,1:3)')';
    %fibre_sheet(i,4:6)=(F*sheet(i,2:4)')';
    
    DeformationGrad(i,:,:)=F;
end

%write out fibre data
fid1 = fopen([filepath 'fibreDeformation_TemplateToTarget.txt'],'w');
 
for i = 1 : size(fibre_sheet,1)
    fprintf(fid1, '%f\t %f\t %f\n', fibre_sheet(i,1),fibre_sheet(i,2),fibre_sheet(i,3));
end
fclose(fid1);

%write out template node data after deformation for later mapping
for i=1:size(node,1)
    node_deform(i,:)=node(i,:)+node_dxdydz(i,:);
end

fid2 = fopen([filepath 'nodeDeformed_TemplateToTarget.txt'],'w');
 
for i = 1 : size(node_deform,1)
    fprintf(fid2, '%f\t %f\t %f\n', node_deform(i,1),node_deform(i,2),node_deform(i,3));
end
fclose(fid2);





