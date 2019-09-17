Run LDDMM python cod in 'deformetrica' conda environment when setting surface mesh of cannie heart as initial template and surface mesh of neonatal porcine heart as target template.
In addtion, you neet to copy the template and target vtk file to corresponding working folder.

The vtk reader now only support 
float for points 

CELLS needs to change as POLYGONS

otherwise it will just through errors. Will need to update vtkwriter. 
22/03/2019