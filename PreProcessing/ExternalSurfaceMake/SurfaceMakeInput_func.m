
function [node, element, S1, S2, S3, S4] = SurfaceMakeInput_func(keywords) 
% load input file and choose template or target mesh data
% will only support Template or Target
global projectConfig;

% keywrods_str={'Template','Target'};
% [s,v] = listdlg('PromptString','Select a file:',...
%                 'SelectionMode','single',...
%                 'ListString',keywrods_str);
% keyword = keywrods_str{s};

% str=['E:\HaoGao\PhDs\PhD_DebaoGuan\LDDMM MAP\LDDMM_Mapping\InputOutputFile\' keyword];
if strcmp(keywords, 'Target')
    cd(projectConfig.meshDir);
    node=load([keywords '_node.txt']);
    element=load([keywords '_element.txt']);

    S1=load([keywords '_S1.txt']);
    S2=load([keywords '_S2.txt']);
    S3=load([keywords '_S3.txt']);
    S4=load([keywords '_S4.txt']);
    cd(projectConfig.workingDir);
elseif strcmp(keywords, 'Template')
    cd(projectConfig.projectDir);
    node=load([keywords '_node.txt']);
    element=load([keywords '_element.txt']);

    S1=load([keywords '_S1.txt']);
    S2=load([keywords '_S2.txt']);
    S3=load([keywords '_S3.txt']);
    S4=load([keywords '_S4.txt']);
    cd(projectConfig.workingDir);
else
    disp('wrong keywords in SurfaceMakeInput_func, only support Template or Target');
end

