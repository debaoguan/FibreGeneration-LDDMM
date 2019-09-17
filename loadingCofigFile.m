workingDir = pwd();
global projectConfig; 

%%%whole lv manual segmentation configuration
if ispc
    path(path, '.\ComputingLDDMM');
    path(path, '.\PostProcessing\BodyNodeDisplacement');
    path(path, '.\PostProcessing\DeformationGradientTensor');
    path(path, '.\PostProcessing\MapFibreFromTemplateToTarget');
    path(path, '.\PostProcessing\SurfaceNodeDisplacement');
    path(path, '.\PreProcessing\ChangeBodyDateFormat');
    path(path, '.\PreProcessing\ChangeSurfaceDateFormat');
    path(path, '.\PreProcessing\DefineSheetDirection');
    path(path, '.\PreProcessing\ExternalSurfaceMake');
    path(path, '.\PreProcessing\MapFibreFromTableToMesh');
end

if ismac
    path(path, './ComputingLDDMM');
    path(path, './PostProcessing/BodyNodeDisplacement');
    path(path, './PostProcessing/DeformationGradientTensor');
    path(path, './PostProcessing/MapFibreFromTemplateToTarget');
    path(path, './PostProcessing/SurfaceNodeDisplacement');
    path(path, './PreProcessing/ChangeBodyDateFormat');
    path(path, './PreProcessing/ChangeSurfaceDateFormat');
    path(path, './PreProcessing/DefineSheetDirection');
    path(path, './PreProcessing/ExternalSurfaceMake');
    path(path, './PreProcessing/MapFibreFromTableToMesh');
end

workingDir = pwd();


if ispc 
    [FileName,PathName,~] = uigetfile('..\Projects\*.m');
elseif ismac || isunix 
    [FileName,PathName,~] = uigetfile('../Projects/*.m');
end
% [FileName, PathName] = uigetfile( ...
%        {'*.m'}, ...
%         'Pick a file');
projectConfig.projectDir = PathName;
projectConfig.projectConfig = FileName;
projectConfig.workingDir = workingDir;


cd(projectConfig.projectDir);
run(projectConfig.projectConfig);
cd(workingDir);
