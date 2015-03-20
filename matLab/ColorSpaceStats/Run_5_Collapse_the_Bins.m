load(strcat(dirName,'/',name,'_Skinned_Rot_TopTail'));
eval(strcat(name,'_Skinned_Rot_TopTail_CaCb = ', name,'_Skinned_Rot_TopTail.collapse(1, [1,256])'));

save(strcat(dirName,'/',name,'_Skinned_Rot_TopTail_CaCb'),strcat( name,'_Skinned_Rot_TopTail_CaCb'));