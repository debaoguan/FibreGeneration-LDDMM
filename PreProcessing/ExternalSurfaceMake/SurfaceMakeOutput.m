% write output files

% write out the surface node data
fid1 = fopen([str '_node_surface.txt'],'w');
 
for i = 1 : size(node_suf,1)
    fprintf(fid1, '%i,\t%.10f, \t%.10f, \t%.10f\n', i,node_suf(i,1),node_suf(i,2),node_suf(i,3));
end
fclose(fid1);

% write out the surface element data
fid2 = fopen([str '_element_surface.txt'],'w');
 
for i = 1 : size(Tedele,1)
    fprintf(fid2, '\t%i, \t%i, \t%i,\t%i\n', i,Tedele(i,1),Tedele(i,2),Tedele(i,3));
end
fclose(fid2);

% write out the marking surface node data
fid3 = fopen([ str '_group.txt'],'w');
 
for i = 1 : size(group,1)
    fprintf(fid3, '%i\t %i\n', group(i,1),group(i,2));
end
fclose(fid3);