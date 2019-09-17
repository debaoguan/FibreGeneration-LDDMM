function DTMRIDataSet = MapFibreFromTableToMesh_fileinput_func()

global projectConfig;
workingDir = pwd();
DTMRIDataSetFileName = projectConfig.DTMRIDataSetFileName;

cd(projectConfig.DTMRIDataDir);

element1=load(DTMRIDataSetFileName.element);
node1=load(DTMRIDataSetFileName.node);
fibre=load(DTMRIDataSetFileName.fgeo);
sheet=load(DTMRIDataSetFileName.sgeo);
load(DTMRIDataSetFileName.e1);
load(DTMRIDataSetFileName.e2);
load(DTMRIDataSetFileName.e3);

load(DTMRIDataSetFileName.v11);
load(DTMRIDataSetFileName.v12);
load(DTMRIDataSetFileName.v13);
load(DTMRIDataSetFileName.v21);
load(DTMRIDataSetFileName.v22);
load(DTMRIDataSetFileName.v23);
load(DTMRIDataSetFileName.v31);
load(DTMRIDataSetFileName.v32);
load(DTMRIDataSetFileName.v33);

DTMRIDataSet.element = element1;
DTMRIDataSet.node = node1;
DTMRIDataSet.fibre = fibre;
DTMRIDataSet.sheet = sheet;
DTMRIDataSet.e1 = e1;
DTMRIDataSet.e2 = e2;
DTMRIDataSet.e3 = e3;
DTMRIDataSet.v11 = v11;
DTMRIDataSet.v12 = v12;
DTMRIDataSet.v13 = v13;
DTMRIDataSet.v21 = v21;
DTMRIDataSet.v22 = v22;
DTMRIDataSet.v23 = v23;
DTMRIDataSet.v31 = v31;
DTMRIDataSet.v32 = v32;
DTMRIDataSet.v33 = v33;

cd(workingDir);