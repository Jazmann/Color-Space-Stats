load(strcat(dirName,'/',name,'_Skinned_Rot_TopTail_CaCb'));
eval(strcat(name,'_Skinned_Rot_TopTail_CaCb_Despec = ', name,'_Skinned_Rot_TopTail_CaCb.removeZeros(2)'));

save(strcat(dirName,'/',name,'_Skinned_Rot_TopTail_CaCb_Despec'),strcat( name,'_Skinned_Rot_TopTail_CaCb_Despec'));