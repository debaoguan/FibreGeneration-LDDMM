 % this code is to make boundary file for poisson computation in FENICS. 
 % Here, we set external surface as number 1 and inner surface as 0, and 
 % define sheet direction according gradient variation.
 % 
 % these surface node file are from ABAQUS set 
%  clear all; close all;
function Target_Surface_poissonBC_func()
global projectConfig;


filepath=projectConfig.meshDir;
lv_node = load([filepath 'Target_lv_node.txt']);
rv_node = load([filepath 'Target_rv_node.txt']);
epi_node = load([filepath 'Target_epi_node.txt']);
sep_node = load([filepath 'Target_sep_node.txt']);
node=load([filepath 'Target_node.txt']);
data =[];

%epi=1
k=0;
for i=1:size(epi_node,1)
    for j=1:size(epi_node,2)
        if epi_node(i,j)~=0
            k=k+1;
            data(k,1)=epi_node(i,j);
            data(k,2)=1;
            data(k,3)=1;
        end
    end
end

%lv=0
for i=1:size(lv_node,1)
    for j=1:size(lv_node,2)
        if lv_node(i,j)~=0
            k=k+1;
            data(k,1)=lv_node(i,j);
            data(k,2)=1;
            data(k,3)=0;
        end
    end
end

%sep=1
for i=1:size(sep_node,1)
    for j=1:size(sep_node,2)
        if sep_node(i,j)~=0
            k=k+1;
            data(k,1)=sep_node(i,j);
            data(k,2)=1;
            data(k,3)=1;
        end
    end
end

%rvfree=0
for i=1:size(rv_node,1)
    for j=1:size(rv_node,2)
        if rv_node(i,j)~=0 && ~ismember(rv_node(i,j),sep_node)
            k=k+1;
            data(k,1)=rv_node(i,j);
            data(k,2)=1;
            data(k,3)=0;
        end
    end
end

group = [];
for i=1:size(node,1)
    if ismember(i,data(:,1))
        row=find(data(:,1)==i);
        group(i,:)=data(row,2:3);
    else
        group(i,:)=[0 0];
    end
end

        
% write out the boundary value file 
fid2 = fopen([filepath 'Target_surface_BCS.txt'],'w');
 
for i = 1 : size(group,1)
    fprintf(fid2, '%i\t %i\n', group(i,1),group(i,2));
end
fclose(fid2);






            

