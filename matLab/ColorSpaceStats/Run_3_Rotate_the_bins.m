% use a theta=0, signed factored, normalised, shifted transform 
fR=transform(0, 'fRs', 'nLCaCb', 1, 8);
eval(strcat(name,'_Skinned_Rot = ', name,'_Skinned.rot(fR)'));
save(strcat(dirName,'/',name,'_Skinned_Rot'),strcat( name,'_Skinned_Rot'));