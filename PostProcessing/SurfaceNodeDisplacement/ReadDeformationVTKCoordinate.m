
% read template surface node coordinate
filepath='D:\DBGuan\DTMRImapping\MatlabCode - Copy\InputOutputFile\';
fid1 = fopen([filepath 'DeterministicAtlas__EstimatedParameters__Template_putamen.vtk'], 'r');
xmlstrs={};
% close file when we're done
CC = onCleanup (@() fclose(fid1));

xmlstrs = {fgetl(fid1)};

find = 1;
kstart=0;kend=0;k=0;

while ischar (xmlstrs{find})

    find = find + 1;

    xmlstrs{find,1} = fgetl(fid1);

    if ~isempty(strfind (xmlstrs{find,1}, 'POINTS'))
        kstart=find+1;
    end
    if ~isempty(strfind (xmlstrs{find,1}, 'POLYGONS'))
         break;
    end
    if find>=kstart & kstart>0
        S1 = regexp(xmlstrs{find,1}, '\s+', 'split');

        k=k+1;
        for ii=1:3
            Template_data(k,ii)=str2num(S1{ii});
        end
    end

end

% read target surface node coordinate
fid1 = fopen([filepath 'DeterministicAtlas__EstimatedParameters__Template_putamen.vtk'], 'r');
xmlstrs={};
% close file when we're done
CC = onCleanup (@() fclose(fid1));

xmlstrs = {fgetl(fid1)};

find = 1;
kstart=0;kend=0;k=0;

while ischar (xmlstrs{find})

    find = find + 1;

    xmlstrs{find,1} = fgetl(fid1);

    if ~isempty(strfind (xmlstrs{find,1}, 'POINTS'))
        kstart=find+1;
    end
    if ~isempty(strfind (xmlstrs{find,1}, 'POLYGONS'))
         break;
    end
    if find>=kstart & kstart>0
        S1 = regexp(xmlstrs{find,1}, '\s+', 'split');

        k=k+1;
        for ii=1:3
            Target_data(k,ii)=str2num(S1{ii});
        end
    end

end


