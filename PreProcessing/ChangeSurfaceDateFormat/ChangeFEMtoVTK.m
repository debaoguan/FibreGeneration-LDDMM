% This code is to change FEM data to VTK format because LDDMM python code only can 
% deal with vtk file


clear all; close all;

% choose data
keywrods_str={'Template','Target'};
[s,v] = listdlg('PromptString','Select a file:',...
                'SelectionMode','single',...
                'ListString',keywrods_str);
keyword = keywrods_str{s};

filepath=['D:\DBGuan\DTMRImapping\MatlabCode - Copy\InputOutputFile\' keyword];

node=load([filepath '_node_surface.txt']);
element=load([filepath '_element_surface.txt']);

ele=element(:,2:4);
nod=node(:,2:4);

%define the output file name
%filename = '_Heart_surface';

elev=zeros(size(ele,1),1);

writevtkfile(filepath,nod,ele,elev);