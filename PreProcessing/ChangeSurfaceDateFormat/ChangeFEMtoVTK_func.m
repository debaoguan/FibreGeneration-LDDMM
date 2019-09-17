% This code is to change FEM data to VTK format because LDDMM python code only can 
% deal with vtk file

function ChangeFEMtoVTK_func()
global projectConfig;

keywrods_str={'Template','Target'};

for strIndex = 1 : length(keywrods_str)
   keyword = keywrods_str{strIndex};

   if strcmp(keyword, 'Template') 
     filepath=[projectConfig.projectDir 'Template'];
   elseif strcmp(keyword, 'Target')
    filepath=[projectConfig.projectDir 'Target'];
   else
       disp('Keyword is not right!')
   end
   

     node=load([filepath '_node_surface.txt']);
     element=load([filepath '_element_surface.txt']);

     ele=element(:,2:4);
     nod=node(:,2:4);

    %define the output file name
    %filename = '_Heart_surface';

     elev=zeros(size(ele,1),1);

    writevtkfile(filepath,nod,ele,elev);
end