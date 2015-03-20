
load(strcat(dirName,'/',name,'_Skinned_Rot'));
eval(strcat(name,'_Skinned_Rot_TopTail = Bin.topTail(', name,'_Skinned_Rot, 42)'));

save(strcat(dirName,'/',name,'_Skinned_Rot_TopTail'),strcat( name,'_Skinned_Rot_TopTail'));