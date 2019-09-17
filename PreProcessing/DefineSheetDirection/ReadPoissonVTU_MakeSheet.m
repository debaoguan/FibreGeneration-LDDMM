% this code is to make sheet direction according gradient data
clear all;close all;
filepath='D:\DBGuan\DTMRImapping\MatlabCode - Copy\InputOutputFile\';

%% gradient
%% open the file gradient
fid1 = fopen([filepath 'Target_poisson_gradu000000.vtu'], 'r');
xmlstrs={};
% close file when we're done
CC = onCleanup (@() fclose(fid1));

xmlstrs = {fgetl(fid1)};

find = 1;

while ischar (xmlstrs{find})

    find = find + 1;

    xmlstrs{find,1} = fgetl(fid1);

    if ~isempty(strfind (xmlstrs{find,1}, 'AppendedData'))

        xmlstrs = [ xmlstrs; {'</AppendedData>'; '</VTKFile>'} ];

        % could get file position like this? how many bytes?
        datapos = ftell (fid1) + 4;

        break;
    end

end

S1 = regexp(xmlstrs{14}, '\s+', 'split');

for i=6:length(S1)-2
    str=S1{i};
    data_x(i-5,1)=str2num(str);
end

fclose(fid1);

k=0;
for i=1:3:size(data_x,1)
    a=[data_x(i) data_x(i+1) data_x(i+2)];
    k=k+1;
    na=norm(a);
    if na~=0
        vec_gra(k,:)=a/na;
    else
        vec_gra(k,:)=a;
    end
end

element=load([filepath 'Target_element.txt']);
%compute central vector as element gradient vector
for i=1:size(element,1)
    v1=[vec_gra(element(i,2),:); vec_gra(element(i,3),:);vec_gra(element(i,4),:);vec_gra(element(i,5),:)];
    vector(i,:)=mean(v1)/norm(mean(v1));
end
    
    
%write out sheet direction
fid1 = fopen([filepath 'Target_sheet.txt'],'w');
 
for i = 1:size(vector,1)
    fprintf(fid1, '%i\t, %f\t, %f\t, %f\n', i, vector(i,1),vector(i,2),vector(i,3));
end
fclose(fid1);


