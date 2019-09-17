%this code is to read the poisson data from vtu file dx, dy, dz
%please note, you need to add one tab after 'format="ascii">' 
%because this code identify number by tab. Actually, we find line 14
%is displacment value and then we just add one tab after 'format="ascii">' in that line
function ReadResultsData_func()
global projectConfig;

filepath = projectConfig.meshDir;
% filepath='D:\DBGuan\DTMRImapping\MatlabCode - Copy\InputOutputFile\';
fid1 = fopen([filepath '\CaninetoDB_dx000000.vtu'], 'r');
xmlstrs={};
% close file when we're done
% CC = onCleanup (@() fclose(fid1));

xmlstrs = {fgetl(fid1)};

find = 1;

while ischar (xmlstrs{find})

    find = find + 1;

    xmlstrs{find,1} = fgetl(fid1);
    

end

%extract the displacment line
data_x = [];
S1 = regexp(xmlstrs{14}, '\s+', 'split');
%change string to number and save
for i=5:length(S1)-2
    str=S1{i};
    data_x(i-4,1)=str2num(str);
end

fclose(fid1);



%% open the file dy
close all;
xmlstrs={};
fid2 = fopen([filepath '\CaninetoDB_dy000000.vtu'], 'r');

% close file when we're done
% CC = onCleanup (@() fclose(fid2));

xmlstrs = {fgetl(fid2)};

find = 1;

while ischar (xmlstrs{find})

    find = find + 1;

    xmlstrs{find,1} = fgetl(fid2);


end

S1 = regexp(xmlstrs{14}, '\s+', 'split');

data_y = [];
for i=5:length(S1)-2
    str=S1{i};
    data_y(i-4,1)=str2num(str);
end

fclose(fid2);



%% open the file dz
close all;
fid3 = fopen([filepath '\CaninetoDB_dz000000.vtu'], 'r');
xmlstrs={};
% close file when we're done
% CC = onCleanup (@() fclose(fid3));

xmlstrs = {fgetl(fid3)};

find = 1;

while ischar (xmlstrs{find})

    find = find + 1;

    xmlstrs{find,1} = fgetl(fid3);

    
end

S1 = regexp(xmlstrs{14}, '\s+', 'split');

data_z = [];
for i=5:length(S1)-2
    str=S1{i};
    data_z(i-4,1)=str2num(str);
end

fclose(fid3);





%% combine dx dy dz together

dxdydz=[data_x data_y data_z];

filepath = projectConfig.projectDir;
fid4 = fopen([filepath '\Template_node_dxdydz.txt'],'w');
 
for i = 1 : size(dxdydz,1)
    fprintf(fid4, '%f\t %f\t %f\n', dxdydz(i,1),dxdydz(i,2),dxdydz(i,3));
end
fclose(fid4);
%%




