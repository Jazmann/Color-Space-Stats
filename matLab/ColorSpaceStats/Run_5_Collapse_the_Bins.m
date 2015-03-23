load(strcat(dirName,'/',name,'_Skinned_Rot_TopTail'));
% Collapse the luminocity axis.
eval(strcat(name,'_Skinned_Rot_TopTail_CaCb = ', name,'_Skinned_Rot_TopTail.collapse(1, [1,256])'));
% Save the result.
save(strcat(dirName,'/',name,'_Skinned_Rot_TopTail_CaCb'),strcat( name,'_Skinned_Rot_TopTail_CaCb'));
