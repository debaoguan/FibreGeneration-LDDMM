%map the deformed fibre from template to target mesh through comparing the central 
%coordinate of element, i.e, min|X_template-X_target|, where X is the central coordinate 
%of element.

%After getting fibre for target mesh, combining with sheet collagen and deducing 
%sheet-normal direction.

clear all; close all;
filepath='D:\DBGuan\DTMRImapping\MatlabCode - Copy\InputOutputFile\';

% read the element and node from deformed template 
%'Step 1: Read data' 
element1=load([filepath 'Template_element.txt']);
node1=load([filepath 'nodeDeformed_TemplateToTarget.txt']);
fibre_sheet=load([filepath 'fibreDeformation_TemplateToTarget.txt']);

%compute central coordinate
for i=1:size(element1,1)
    center=[];
    for j=1:4
        xyztet1(1,j)=node1(element1(i,j+1),2);
        xyztet1(2,j)=node1(element1(i,j+1),3);
        xyztet1(3,j)=node1(element1(i,j+1),4);
    end
    center=mean(xyztet1,2);
    map1(i,1)=i;
    map1(i,2:4)=center';
    map1(i,5:10)=fibre_sheet(i,1:3);
end

% read the element and node from target mesh
%'Step 2: Read data'
element2=load([filepath '\DB_element.txt');
node2=load([filepath 'DB_node.txt');

for i=1:size(element2,1)
    center=[];
    for j=1:4
        xyztet2(1,j)=node2(element2(i,j+1),2);
        xyztet2(2,j)=node2(element2(i,j+1),3);
        xyztet2(3,j)=node2(element2(i,j+1),4);
    end
    
    center=mean(xyztet2,2);
    dis0=1000; mrow=0;%initail value
    
    for k=1:size(map1,1)
        cen=[];dis=[];
        cen=map1(k,2:4);
        dom=center'-cen;
		%searching in reasonable range and choose min value
        if abs(dom(1))<3 & abs(dom(3))<3 & abs(dom(3))<3
            dis1=norm(dom);
            if dis1<dis0
                mrow=k;
                dis0=dis1;
            end
        end
    end
   % mr=find(dis(:,2)==min(dis(:,2)));
   % mrow=dis(mr,1);
    
   %map2(i,1)=i;
   % map1(i,2:4)=center';
   % map1(i,5:10)=fibre_sheet(mrow,:);
    fibre_sheet_traget(i,:)=fibre_sheet(mrow,1:3);
   %to mark the process
    if mod(i,10000)==0
       num2str(i)
    end
end
%write out the mapping fibre for target mesh
fid1 = fopen([filepath 'Target_fibre.txt'],'w');
 
for i = 1 : size(fibre_sheet_traget,1)
    fprintf(fid1, 'i,\t%f, \t%f, \t%f\n', i, fibre_sheet_traget(i,1),fibre_sheet_traget(i,2),fibre_sheet_traget(i,3));
end
fclose(fid1);


%combining with collagen fibre along sheet direction

fibre=fibre_sheet_traget;
sheet=load([filepath 'Template_sheet.txt']);

for i=1:size(f,1)
    a=fibre(i,:);
    b=sheet(i,:);
    c=cross(a,b);
    d=cross(c,a);
    
    
    normal=c/norm(c);
    sheetnew=d/norm(d);
    
    f_s_n(i,1:3)=a;
    f_s_n(i,4:6)=sheetnew;
    f_s_n(i,7:9)=normal;
    
end

fid2 = fopen([filepath 'Target_f_s_n.txt'],'w');
 
for i = 1 : size(f_s_n,1)
    fprintf(fid2, '%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n', f_s_n(i,1), f_s_n(i,2), f_s_n(i,3)...
        , f_s_n(i,4), f_s_n(i,5), f_s_n(i,6), f_s_n(i,7), f_s_n(i,8), f_s_n(i,9));
end
fclose(fid2);


