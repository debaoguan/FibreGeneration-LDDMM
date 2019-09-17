%map the deformed fibre from template to target mesh through comparing the central 
%coordinate of element, i.e, min|X_template-X_target|, where X is the central coordinate 
%of element.

%After getting fibre for target mesh, combining with sheet collagen and deducing 
%sheet-normal direction.
function MapFibreFromTemplateToTarget_func_hg()
global projectConfig;

%clear all; close all;
%filepath='D:\DBGuan\DTMRImapping\MatlabCode - Copy\InputOutputFile\';
filepath = projectConfig.projectDir;

% read the element and node from deformed template 
%'Step 1: Read data' 
element1=load([filepath '\Template_element.txt']); %[elem_index, n1, n2, n3, n4]
% node1=load([filepath '\Template_node.txt']);
node1=load([filepath 'nodeDeformed_TemplateToTarget.txt']);%[x, y, z]
fibre_sheet=load([filepath '\fibreDeformation_TemplateToTarget.txt']); %[f1, f2, f3]

%%output the template_target_mesh to compare with the target mesh
template_target_mesh_file_name = [filepath '\template_target_mesh_mapping_fibre'];
writevtkfile(template_target_mesh_file_name,node1,element1(:, 2:5),fibre_sheet);

%compute the central coordinate
template_target_centre = zeros(size(element1,1),3); %% [x, y, z]
for i = 1 : size(element1, 1)
    node_list = element1(i, 2:5);
    xyztet = node1(node_list, :);
    template_target_centre(i,:) = [mean(xyztet(:,1)), mean(xyztet(:,2)), mean(xyztet(:,3))]; 
end

% read the element and node from target mesh
%'Step 2: Read data'
filepath = projectConfig.meshDir;
element2=load([filepath '\Target_element.txt']);
node2=load([filepath '\Target_node.txt']);

fibre_sheet_traget = zeros([size(element2,1), 3]);

%%compute the central coordinate for the target mesh 
target_centre = zeros(size(element2,1), 3);
for i = 1 : size(element2, 1)
    node_list = element2(i, 2: 5);
    xyztet = node2(node_list, 2:4);
    target_centre(i, :) = [mean(xyztet(:,1)), mean(xyztet(:,2)), mean(xyztet(:,3))];
end

%% find the closet correspondence
temp_target_x = template_target_centre(:,1);
temp_target_y = template_target_centre(:,2);
temp_target_z = template_target_centre(:,3);
for itarget = 1 : size(element2,1)
    centre_x = target_centre(itarget, 1);
    centre_y = target_centre(itarget, 2);
    centre_z = target_centre(itarget, 3);
 
    dis_t = ((temp_target_x-centre_x).^2 + (temp_target_y - centre_y).^2 + (temp_target_z - centre_z).^2);
    itemplate = find(dis_t == min(dis_t));
     fibre_sheet_traget(itarget,:)=fibre_sheet(itemplate(1),1:3);
    
     if mod(itarget,10000)==0
       num2str(itarget)
     end
    
end
%%output the template_target_mesh to compare with the target mesh
filepath = projectConfig.projectDir;
target_mesh_file_name = [filepath '\target_mesh_mapping_fibre'];
writevtkfile(target_mesh_file_name,node2(:,2:4),element2(:, 2:5),fibre_sheet_traget);

%write out the mapping fibre for target mesh
filepath = projectConfig.projectDir;
fid1 = fopen([filepath 'Target_fibre_hg.txt'],'w');
 
for i = 1 : size(fibre_sheet_traget,1)
    fprintf(fid1, '%f\t %f\t %f\n', fibre_sheet_traget(i,1),fibre_sheet_traget(i,2),fibre_sheet_traget(i,3));
end
fclose(fid1);


%combining with collagen fibre along sheet direction

fibre=fibre_sheet_traget;
sheet=load([filepath 'Target_sheet.txt']);
sheet = sheet(:, 2:4);
f_s_n = zeros( [size(fibre,1), 9] );
for i=1:size(fibre,1)
    a=fibre(i,:);
    b=sheet(i,:);
    c=cross(a,b);
    d=cross(c,a);
    
    
    normal=c/norm(c);
    sheetnew=d/norm(d);
    
    f_s_n(i,1:3)=a;
    f_s_n(i,4:6)=sheetnew;
    f_s_n(i,7:9)=normal;
    
end

fid2 = fopen([filepath 'Target_f_s_n_hg.txt'],'w');
 
for i = 1 : size(f_s_n,1)
    fprintf(fid2, '%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n', f_s_n(i,1), f_s_n(i,2), f_s_n(i,3)...
        , f_s_n(i,4), f_s_n(i,5), f_s_n(i,6), f_s_n(i,7), f_s_n(i,8), f_s_n(i,9));
end
fclose(fid2);