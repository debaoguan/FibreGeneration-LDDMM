% This code is to map fibre from DTMRI dataset to corresponding mesh of geometry.
% DTMRI dataset includes collagen fibre angle computed according to eigenvector 
% and local coordinate, details refering to papers on http://cvrgrid.org/data/ex-vivo 
% Here, we take the first eigenvector as fibre direction, and map fibre and element according to
% global coordinate.
%*********************************************************
% input file includes
% element and node: data from mesh of cannie heart geometry
% fibre and sheet: deducing angle in local coordinate
% e1; e2 and e3: eigenvalue from DTMRI
% v11, v12, v13: components of first eigenvector
% v21, v22, v23: components of first eigenvector
% v31, v32, v33: components of first eigenvector
% Fianlly, we write out all the data in respect to mesh element but we only take first
% eigenvector as fibre direction.

clear all; close all;

%load input file
MapFibreFromTableToMesh_fileinput;

%compute pixel network size
dx=(63+17)/255; dy=(50+30)/255; dz=(73+19)/115;


mad=[]; %for accumulation of empty element
for i=1:size(element1,1)
    center=[];
	%compute central coordinate of each element
    for j=1:4
        xyztet1(1,j)=node1(element1(i,j+1),2);
        xyztet1(2,j)=node1(element1(i,j+1),3);
        xyztet1(3,j)=node1(element1(i,j+1),4);
    end
    center=mean(xyztet1,2);
	
    %compute corresponding pixel coordinate
    x=round((63-center(1))/dx+1);
    y=round((50-center(2))/dy+1);
    z=round((73-center(3))/dz+1);
    
	%extract fibre and sheet angle
	
    a=fibre.fgeo(x,y,z);
    b=sheet.sgeo(x,y,z);
    
    kr=0;kc=0;kz=0;
    
	%judge whether there is real data in pixel data
	%if no, searching it in near region
    if isnan(a) | isnan(b)
        kk=0; row=[];col=[];zol=[];dis=[];
        for kr=-10:10
            if kr+x >256
                kr=256-x;
            elseif kr+x<=0
                kr=1-x;
            end 
            for kc=-10:10
                if kc+y >256
                    kc=256-y;
                elseif kc+y<=0
                    kc=1-y;
                end 
                for kz=-5:5
                    if kz+z >256
                        kz=256-z;
                    elseif kz+z<=0
                        kz=1-z;
                    end 
                    a=fibre.fgeo(x+kr,y+kc,z+kz);
                    b=sheet.sgeo(x+kr,y+kc,z+kz);
                    if ~isnan(a) & ~isnan(b)
                        kk=kk+1;
                        row(kk)=kr; col(kk)=kc; zol(kk)=kz;
                    end
                end
            end
        end
        
		%compute distance between nearby pixel and target pixel
        for ki=1:length(row)
            dis(ki)=norm([row(ki)-x col(ki)-y zol(ki)-z]);
        end
        
		%if still no real data, makring it for second searching in greater range
		%if there is real data, taking the nearest one
        if length(row)==0
            mad=[mad;i];
            kr=0;kc=0;kz=0;
        else
        
            rmin=find(dis==min(dis));
            kr=row(rmin(1));
            kc=col(rmin(1));
            kz=zol(rmin(1));
        end
    end
    
	%extract all the data from dataset to mesh element
    a=fibre.fgeo(x+kr,y+kc,z+kz);
    b=sheet.sgeo(x+kr,y+kc,z+kz);
    
    fibre_sheet(i,1)=a;
    fibre_sheet(i,2)=b;
    fibre_sheet(i,3)=e1(x+kr,y+kc,z+kz);
    fibre_sheet(i,4)=e2(x+kr,y+kc,z+kz);
    fibre_sheet(i,5)=e3(x+kr,y+kc,z+kz);
    fibre_sheet(i,6:8)=[v11(x+kr,y+kc,z+kz) v12(x+kr,y+kc,z+kz) v13(x+kr,y+kc,z+kz)];
    fibre_sheet(i,9:11)=[v21(x+kr,y+kc,z+kz) v22(x+kr,y+kc,z+kz) v23(x+kr,y+kc,z+kz)];
    fibre_sheet(i,12:14)=[v31(x+kr,y+kc,z+kz) v32(x+kr,y+kc,z+kz) v33(x+kr,y+kc,z+kz)];
end

% the second searching for above empty element in greater range
mad2=[];
for i=1:size(mad,1)
    center=[];
    for j=1:4
        xyztet1(1,j)=node1(element1(mad(i),j+1),2);
        xyztet1(2,j)=node1(element1(mad(i),j+1),3);
        xyztet1(3,j)=node1(element1(mad(i),j+1),4);
    end
    center=mean(xyztet1,2);
    
    x=round((63-center(1))/dx+1);
    y=round((50-center(2))/dy+1);
    z=round((73-center(3))/dz+1);
    
    a=fibre.fgeo(x,y,z);
    b=sheet.sgeo(x,y,z);
    
    kr=0;kc=0;kz=0;
    
    if isnan(a) | isnan(b)
        kk=0; row=[];col=[];zol=[];dis=[];
        for kr=1:2:256
            for kc=1:2:256
                for kz=1:2:116
                    a=fibre.fgeo(kr,kc,kz);
                    b=sheet.sgeo(kr,kc,kz);
                    if ~isnan(a) & ~isnan(b)
                        kk=kk+1;
                        row(kk)=kr; col(kk)=kc; zol(kk)=kz;
                    end
                end
            end
        end
            
        for ki=1:length(row)
            dis(ki)=norm([row(ki)-x col(ki)-y zol(ki)-z]);
        end
        
        if length(row)==0
            mad2=[mad2;mad(i)];
            kr=0;kc=0;kz=0;
        else
        
            rmin=find(dis==min(dis));
            kr=row(rmin(1));
            kc=col(rmin(1));
            kz=zol(rmin(1));
        end
    end
    %extract data            
    a=fibre.fgeo(kr,kc,kz);
    b=sheet.sgeo(kr,kc,kz);
    
    fibre_sheet(mad(i),1)=a;
    fibre_sheet(mad(i),2)=b;
    fibre_sheet(i,3)=e1(kr,kc,kz);
    fibre_sheet(i,4)=e2(kr,kc,kz);
    fibre_sheet(i,5)=e3(kr,kc,kz);
    fibre_sheet(i,6:8)=[v11(kr,kc,kz) v12(kr,kc,kz) v13(kr,kc,kz)];
    fibre_sheet(i,9:11)=[v21(kr,kc,kz) v22(kr,kc,kz) v23(kr,kc,kz)];
    fibre_sheet(i,12:14)=[v31(kr,kc,kz) v32(kr,kc,kz) v33(kr,kc,kz)];
  
end

MapFibreFromTableToMesh_fileouput;



