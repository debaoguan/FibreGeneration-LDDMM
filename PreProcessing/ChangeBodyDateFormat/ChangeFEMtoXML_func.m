%This file is to change mesh data to XML format because Fenics only deal with xml format
% clear all; close all;
function ChangeFEMtoXML_func()
global projectConfig;

%choose data 
keywrods_str={'Template','Target'};
% [s,v] = listdlg('PromptString','Select a file:',...
%                 'SelectionMode','single',...
%                 'ListString',keywrods_str);

for keyIndex = 1 : length(keywrods_str)
    keyword = keywrods_str{keyIndex};

    filepath=projectConfig.projectDir;
    if strcmp(keyword, 'Target')
        filepath = projectConfig.meshDir;
    end
    node=load([filepath keyword '_node.txt']);
    element=load([filepath keyword '_element.txt']);

    %begin write .xml
    fid1 = fopen([filepath keyword '.xml'],'w');
    fprintf(fid1, '<?xml version="1.0" encoding="UTF-8"?>\n');
    fprintf(fid1, '\n');
    fprintf(fid1, '<dolfin xmlns:dolfin="http://www.fenicsproject.org">\n');
    fprintf(fid1, '  <mesh celltype="tetrahedron" dim="3">\n');

    %begin node 
    fprintf(fid1, '    <vertices size="%i">\n',size(node,1));
    for i=1:size(node,1)
            fprintf(fid1, '      <vertex index ="%i" x ="%g" y ="%g" z ="%g"/>\n',i-1,node(i,2),node(i,3),node(i,4));
    end
    fprintf(fid1, '    </vertices>\n');

    %begin element
    fprintf(fid1, '    <cells size="%i">\n',size(element,1));
    for i=1:size(element,1)
        fprintf(fid1, '      <tetrahedron index ="%i" v0 ="%i" v1 ="%i" v2 ="%i" v3 ="%i"/>\n',i-1,element(i,2)-1,element(i,3)-1,element(i,4)-1,element(i,5)-1);
    end
    fprintf(fid1, '    </cells>\n');

    fprintf(fid1, '  </mesh>\n');
    fprintf(fid1, '</dolfin>\n');


    fclose(fid1);
    
end


