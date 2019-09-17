clear all; close all; clc;

loadingCofigFile;

if 0 %%very time consuming
%% loading the DTMRI dataset and processing
    DTMRIDataSet = MapFibreFromTableToMesh_fileinput_func(); %% this will just load essential files from DTMRIDataDir
    MapFibreFromTableToMesh_func(DTMRIDataSet);%%this will generate Template_f_s_n.txt file with fibre direction for each element
    cd(projectConfig.projectDir)
    save DTMRIDataSet DTMRIDataSet;
    cd(projectConfig.workingDir);
end

cd(projectConfig.projectDir)
load  DTMRIDataSet;
cd(projectConfig.workingDir);

if 0
%% external surface make. 
%% rigid registration, generate Template_node, Template_element, and Template_fibre_adjust
    AdjustPosition_TemplateToTarget_func();
end

if 0 
%%surfacemake
    SurfaceMake_func();
%%marking the node on surface with number 1 
end

if 0
    %% prepare the VTK format, which will be used by Deformetrica, only the surface mesh
    ChangeFEMtoVTK_func();
end


if 0 
    %% prepare the XML format, which will be used by Fenics for interpolation
    ChangeFEMtoXML_func();
end

if 0
%% prepare the files for fenics to run, mainly set up the boundary, and
%% generate rule-based sheet direction
    Target_Surface_poissonBC_func();
end

msgbox('please run Fenics for sheet direction before moving to the next step');
%% running Fenics for making sheet
%% within sub folder Fenics, using demo_bcs.py

%% after running then it needs to add a tab after '>'
%% <DataArray  type="Float64"  Name="grad(u)"  NumberOfComponents="3" format="ascii">	6.4713812259214479e-02
%% still there is some issue more points which are not used but present in the node file
if 0 
     ReadPoissonVTU_MakeSheet_func(); %%making sheet based on fenics results
end
%% this will generate Target_sheet.txt in projectDir

msgbox('please run Deformatric to warp the template to the target geomery before moving to the next step'); 
%% input files are under folder Deformetric 
%% running LDDMM using deformetric
if 0
%% post processing to compute dx dy dz in the surface
    ComputeDxDyDz_func();
end

%% running fenics for interpolation
msgbox('please run Fenics for interpolation before moving to the next step'); 
%% input files are within Fenics folder, run the following one by one
%% demo_bcs_dx; demo_bcs_dy; demo_bcs_dz

if 0 
%% read in interpolated positions after running Fenics for interpolation
    ReadResultsData_func();
end

%% F calculation 
if 0 
    ComputeDeformationGradient_func();
end


%% f = F f_0
if 0 
      %MapFibreFromTemplateToTarget_func();
      MapFibreFromTemplateToTarget_func_hg(); %% faster within 3 mins
end



