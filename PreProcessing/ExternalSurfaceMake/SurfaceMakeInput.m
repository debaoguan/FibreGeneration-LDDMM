
 
% load input file and choose template or target mesh data

keywrods_str={'Template','Target'};
[s,v] = listdlg('PromptString','Select a file:',...
                'SelectionMode','single',...
                'ListString',keywrods_str);
keyword = keywrods_str{s};

str=['E:\HaoGao\PhDs\PhD_DebaoGuan\LDDMM MAP\LDDMM_Mapping\InputOutputFile\' keyword];
node=load([str '_node.txt']);
element=load([str '_element.txt']);

S1=load([str '_S1.txt']);
S2=load([str '_S2.txt']);
S3=load([str '_S3.txt']);
S4=load([str '_S4.txt']);