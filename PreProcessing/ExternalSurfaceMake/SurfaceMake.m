% This code is to make surface mesh according to the mesh of geometry because
% LDDMM is only can deal with surface mesh format.

% input file includes cannie heart element and node data. Note here, the node is after
% adjustment to make template and target heart in same size range.
% the external surface sets, S1,S2,S3 and S4, of heart are designed by ABAQUS

% The final output files are surface element and node

clear all; close all;
%load input files
SurfaceMakeInput;

%according to surface element defination in ABAQUS to decide surface node number
k=0;
[m1,n1]=size(S1);
for i=1:m1
    for j=1:n1
        if S1(i,j)~=0
            k=k+1;
            Tedele(k,1)=element(S1(i,j),2);
            Tedele(k,2)=element(S1(i,j),3);
            Tedele(k,3)=element(S1(i,j),4);
        end
    end
end

[m2,n2]=size(S2);
for i=1:m2
    for j=1:n2
        if S2(i,j)~=0
            k=k+1;
            Tedele(k,1)=element(S2(i,j),2);
            Tedele(k,2)=element(S2(i,j),5);
            Tedele(k,3)=element(S2(i,j),3);
        end
    end
end

[m3,n3]=size(S3);
for i=1:m3
    for j=1:n3
        if S3(i,j)~=0
            k=k+1;
            Tedele(k,1)=element(S3(i,j),3);
            Tedele(k,2)=element(S3(i,j),5);
            Tedele(k,3)=element(S3(i,j),4);
        end
    end
end

[m4,n4]=size(S4);
for i=1:m4
    for j=1:n4
        if S4(i,j)~=0
            k=k+1;
            Tedele(k,1)=element(S4(i,j),4);
            Tedele(k,2)=element(S4(i,j),5);
            Tedele(k,3)=element(S4(i,j),2);
        end
    end
end

% summarize the node 
a=Tedele(:,1);b=Tedele(:,2);c=Tedele(:,3);d=[a;b;c];
nodeno=unique(d);

% make  surface node data
for i=1:length(nodeno)
    node_suf(i,1)=node(nodeno(i),2);
    node_suf(i,2)=node(nodeno(i),3);
    node_suf(i,3)=node(nodeno(i),4);
    
	%redefine the element number and corresponding nodes
    if nodeno(i)~=i
        row=[];col=[];
        [row,col]=find(Tedele==nodeno(i));
        for j=1:length(row)
            Tedele(row(j),col(j))=i;
        end
    end
end

% marking the node on surface with number 1
for i=1:length(node)
    if ismember(i,nodeno)
        group(i,1)=1;
        group(i,2)=0;
    else
        group(i,1)=0;
        group(i,2)=0;
    end
end

    
% write out the surface node, element data
SurfaceMakeOutput;







          
            